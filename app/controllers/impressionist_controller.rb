# frozen_string_literal: true

require 'digest/sha2'

module ImpressionistController
  module ClassMethods
    def impressionist(opts = {})
      before_action { |c| c.impressionist_subapp_filter(opts) }
    end
  end

  module InstanceMethods
    def self.included(base)
      base.before_action :impressionist_app_filter
    end

    def impressionist(obj, message = nil, opts = {})
      return unless should_count_impression?(opts)

      if obj.respond_to?("impressionable?")
        if unique_instance?(obj, opts[:unique])
          obj.impressions.create(associative_create_statement({ message: message }))
        end
      else
        raise "#{obj.class} is not impressionable!"
      end
    end

    def impressionist_app_filter
      @impressionist_hash = Digest::SHA2.hexdigest("#{Time.now.to_f}#{SecureRandom.hex(16)}")
    end

    def impressionist_subapp_filter(opts = {})
      return unless should_count_impression?(opts)

      actions = opts[:actions]
      actions&.collect!(&:to_s)

      if (actions.blank? || actions.include?(action_name)) && unique?(opts[:unique])
        Impression.create(direct_create_statement)
      end
    end

    protected

    def associative_create_statement(query_params = {})
      filter = ActiveSupport::ParameterFilter.new(Rails.application.config.filter_parameters)

      query_params.reverse_merge!(
        controller_name: controller_name,
        action_name: action_name,
        user_id: user_id,
        request_hash: @impressionist_hash,
        session_hash: session_hash,
        ip_address: sanitized_ip_address,
        referrer: sanitized_referrer,
        params: sanitized_params(filter)
      )
    end

    private

    def bypass
      Impressionist::Bots.bot?(request.user_agent)
    end

    def should_count_impression?(opts)
      !bypass && condition_true?(opts[:if]) && condition_false?(opts[:unless])
    end

    def condition_true?(condition)
      condition.present? ? conditional?(condition) : true
    end

    def condition_false?(condition)
      condition.present? ? !conditional?(condition) : true
    end

    def conditional?(condition)
      condition.is_a?(Symbol) ? send(condition) : condition.call
    end

    def unique_instance?(impressionable, unique_opts)
      unique_opts.blank? || !impressionable.impressions.where(unique_query(unique_opts, impressionable)).exists?
    end

    def unique?(unique_opts)
      unique_opts.blank? || check_impression?(unique_opts)
    end

    def check_impression?(unique_opts)
      impressions = Impression.where(unique_query(unique_opts - [:params]))
      check_unique_impression?(impressions, unique_opts)
    end

    def check_unique_impression?(impressions, unique_opts)
      impressions_present = impressions.exists?
      impressions_present && unique_opts_has_params?(unique_opts) ? check_unique_with_params?(impressions) : !impressions_present
    end

    def unique_opts_has_params?(unique_opts)
      unique_opts.include?(:params)
    end

    def check_unique_with_params?(impressions)
      request_param = params_hash
      impressions.detect { |impression| impression.params == request_param }.nil?
    end

    def unique_query(unique_opts, impressionable = nil)
      full_statement = direct_create_statement({}, impressionable)
      unique_opts.reduce({}) do |query, param|
        query[param] = full_statement[param]
        query
      end
    end

    def direct_create_statement(query_params = {}, impressionable = nil)
      query_params.reverse_merge!(
        impressionable_type: sanitized_impressionable_type,
        impressionable_id: impressionable.present? ? impressionable.id : sanitized_impressionable_id
      )
      associative_create_statement(query_params)
    end

    def sanitized_ip_address
      return nil unless Impressionist.log_ip_address

      ip = request.remote_ip.to_s
      return nil if ip.blank?

      if ip.match?(/\A(?:\d{1,3}\.){3}\d{1,3}\z/) || ip.match?(/\A[a-fA-F0-9:]+\z/)
        ip.slice(0, 45)
      end
    end

    def sanitized_referrer
      return nil unless Impressionist.log_referrer

      referrer = request.referer.to_s
      return nil if referrer.blank?

      begin
        uri = URI.parse(referrer.slice(0, 2048))
        uri.to_s if uri.scheme&.match?(/\Ahttps?\z/)
      rescue URI::InvalidURIError
        nil
      end
    end

    def sanitized_params(filter)
      return {} unless Impressionist.log_params

      filtered = filter.filter(params_hash)
      json = filtered.to_json
      return {} if json.bytesize > Impressionist.max_params_size

      filtered
    end

    def sanitized_impressionable_type
      type = controller_name.singularize.camelize
      return nil unless type.match?(/\A[A-Za-z][A-Za-z0-9_:]*\z/)

      type
    end

    def sanitized_impressionable_id
      id = params[:id]
      return nil if id.blank?

      if id.to_s.match?(/\A\d+\z/)
        id.to_i
      elsif id.to_s.match?(/\A[a-f0-9\-]{36}\z/i)
        id.to_s
      end
    end

    def session_hash
      return nil unless Impressionist.log_session_hash

      id = session.id || request.session_options[:id]
      return nil if id.nil?

      if id.respond_to?(:cookie_value)
        id.cookie_value.to_s.slice(0, 255)
      elsif id.is_a?(Rack::Session::SessionId)
        id.public_id.to_s.slice(0, 255)
      else
        id.to_s.slice(0, 255)
      end
    end

    def params_hash
      request.params.except(:controller, :action, :id)
    end

    def user_id
      user_id = @current_user&.id rescue nil
      user_id = current_user&.id rescue nil if user_id.blank?
      user_id
    end
  end
end