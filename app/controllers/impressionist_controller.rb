require 'digest/sha2'

module ImpressionistController
  module ClassMethods
    def impressionist(opts = {})
      if Rails::VERSION::MAJOR >= 5
        before_action { |c| opts[:async] ? c.impressionist_subapp_filter_async(opts) : c.impressionist_subapp_filter(opts) }
      else
        before_filter { |c| opts[:async] ? c.impressionist_subapp_filter_async(opts) : c.impressionist_subapp_filter(opts) }
      end
    end
  end

  module InstanceMethods
    def self.included(base)
      if Rails::VERSION::MAJOR >= 5
        base.before_action :impressionist_app_filter
      else
        base.before_filter :impressionist_app_filter
      end
    end

    def impressionist(obj, message = nil, opts = {})
      if opts[:async]
        impressionist_async(obj, message, opts)
      else
        if should_count_impression?(opts)
          if obj.respond_to?("impressionable?")
            if unique_instance?(obj, opts[:unique])
              obj.impressions.create(associative_create_statement({ message: message }))
            end
          else
            raise "#{obj.class.to_s} is not impressionable!"
          end
        end
      end
    end

    def impressionist_async(obj, message = nil, opts = {})
      if should_count_impression?(opts)
        if obj.respond_to?("impressionable?")
          if unique_instance?(obj, opts[:unique])
            ImpressionistJob.perform_later(obj, associative_create_statement({ message: message }))
          end
        else
          raise "#{obj.class.to_s} is not impressionable!"
        end
      end
    end

    def impressionist_app_filter
      @impressionist_hash = Digest::SHA2.hexdigest(Time.now.to_f.to_s + rand(10000).to_s)
    end

    def impressionist_subapp_filter(opts = {})
      if should_count_impression?(opts)
        actions = opts[:actions]
        actions.collect! { |a| a.to_s } unless actions.blank?
        if (actions.blank? || actions.include?(action_name)) && unique?(opts[:unique])
          Impression.create(direct_create_statement)
        end
      end
    end

    def impressionist_subapp_filter_async(opts = {})
      if should_count_impression?(opts)
        actions = opts[:actions]
        actions.collect! { |a| a.to_s } unless actions.blank?
        if (actions.blank? || actions.include?(action_name)) && unique?(opts[:unique])
          ImpressionistSubappJob.perform_later(direct_create_statement)
        end
      end
    end

    protected

    def associative_create_statement(query_params = {})
      if Rails::VERSION::MAJOR < 6
        filter = ActionDispatch::Http::ParameterFilter.new(Rails.application.config.filter_parameters)
      else
        filter = ActiveSupport::ParameterFilter.new(Rails.application.config.filter_parameters)
      end

      query_params.reverse_merge!(
        controller_name: controller_name,
        action_name: action_name,
        user_id: user_id,
        request_hash: @impressionist_hash,
        session_hash: session_hash,
        ip_address: request.remote_ip,
        referrer: request.referer,
        params: filter.filter(params_hash)
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
      condition.is_a?(Symbol) ? self.send(condition) : condition.call
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
        impressionable_type: controller_name.singularize.camelize,
        impressionable_id: impressionable.present? ? impressionable.id : params[:id]
      )
      associative_create_statement(query_params)
    end

    def session_hash
      if Rails::VERSION::MAJOR >= 4
        session["init"] = true
        id = session.id.to_s
      else
        id = request.session_options[:id]
      end

      unless id.is_a? String
        id = id.cookie_value if Rack::Session::SessionId.const_defined?(:ID_VERSION) && Rack::Session::SessionId::ID_VERSION == 2
      end

      id
    end

    def params_hash
      request.params.except(:controller, :action, :id)
    end

    def user_id
      user_id = @current_user ? @current_user.id : nil rescue nil
      user_id = current_user ? current_user.id : nil rescue nil if user_id.blank?
      user_id
    end
  end
end
