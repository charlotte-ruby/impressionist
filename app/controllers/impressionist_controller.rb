require 'digest/sha2'

module ImpressionistController
  module ClassMethods
    def impressionist(opts={})
      before_filter { |c| c.impressionist_subapp_filter(opts[:actions], opts[:unique])}
    end
  end

  module InstanceMethods
    def self.included(base)
      base.before_filter :impressionist_app_filter
    end

    def impressionist(obj,message=nil)
      unless bypass
        if obj.respond_to?("impressionable?")
          obj.impressions.create(create_statement({:message => message}))
        else
          raise "#{obj.class.to_s} is not impressionable!"
        end
      end
    end

    def impressionist_app_filter
      @impressionist_hash = Digest::SHA2.hexdigest(Time.now.to_f.to_s+rand(10000).to_s)
    end

    def impressionist_subapp_filter(actions=nil, unique_opts=nil)
      unless bypass
        actions.collect!{|a|a.to_s} unless actions.blank?
        if (actions.blank? || actions.include?(action_name)) && (unique_opts.blank? || is_unique(unique_opts))
          if (!actions.blank? && !unique_opts.blank?)
            logger.info "Restricted to actions #{actions.inspect} and uniqueness for #{unique_opts.inspect}"
          end
          Impression.create(create_statement(
            :impressionable_type => controller_name.singularize.camelize,
            :impressionable_id=> params[:id]
          ))
        end
      end
    end

    private
    
    def bypass
      Impressionist::Bots::WILD_CARDS.each do |wild_card|
        return true if request.user_agent and request.user_agent.downcase.include? wild_card
      end
      Impressionist::Bots::LIST.include? request.user_agent
    end
    
    def is_unique(unique_opts)
      # FIXME think about uniqueness in relation to impressionable_id, impressionable_type and controller_name
      # is controller name redundant? does the controller name always have to match?
      default_statement = create_statement(
        :impressionable_type => controller_name.singularize.camelize,
        :impressionable_id=> params[:id]
        )
      statement = unique_opts.reduce({}) do |query, param|
        query[param] = default_statement[param]
        query
      end
      #logger.debug "Statement params: #{statement.inspect}."
      # always use impressionable type?
      statement[:impressionable_type] = controller_name.singularize.camelize
      #statement[:impressionable_id] = params[:id]
      return Impression.where(statement).size == 0
    end
    
    # creates a statment hash that contains default values for creating an impression (without
    # :impressionable_type and impressionable_id as they are not needed for creating via association).
    def create_statement(query_params={})
      query_params.reverse_merge!(
        :controller_name => controller_name,
        :action_name => action_name,
        :user_id => user_id,
        :request_hash => @impressionist_hash,
        :session_hash => session_hash,
        :ip_address => remote_ip,
        :referrer => request.referer
      )
    end
    
    def session_hash
      # # careful: request.session_options[:id] encoding in rspec test was ASCII-8BIT
      # # that broke the database query for uniqueness. not sure how to solve this issue
      # # seems to depend on app setup/config
      # str = request.session_options[:id]
      # # probably this isn't a fix: request.session_options[:id].encode("ISO-8859-1")
      # logger.debug "Encoding: #{str.encoding.inspect}"
      request.session_options[:id]
    end
    
    def remote_ip
      request.remote_ip
    end
    
    #use both @current_user and current_user helper
    def user_id
      user_id = @current_user ? @current_user.id : nil rescue nil
      user_id = current_user ? current_user.id : nil rescue nil if user_id.blank?
      user_id
    end
  end
end