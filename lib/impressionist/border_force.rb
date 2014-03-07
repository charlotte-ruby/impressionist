require 'ostruct'

module Impressionist
  class BorderForce < OpenStruct

    attr_reader :_payload, :_user_agent_checker

    def initialize(payload, user_agent_checker = Impressionist::UserAgentChecker)
      @_user_agent_checker = user_agent_checker
      @_payload = payload.last
      super(@_payload)
    end

    def call
      savable? { model.save_impression create_statement }
    end

    def savable?
      _user_agent_checker.valid?(user_agent) and unique? and yield
    end

    def unique?
      not(!unique.empty? and model.impression_exist?(get_unique_hash))
    end

    def model
      String === class_name ? class_name.constantize : class_name
    end

    ##
    # Given unique = [ :ip_addres ]
    # And   ip_address = "127.0.0.1"
    # When generate_unique_hash
    # Then #=> { ip_address: "127.0.0.1" }
    #
    def get_unique_hash
      {}.tap { |h| unique.each { |k| h[k] = self.send(k) } }
    end

    def request_hash; unique_id; end

    private

    CONFIG_PARAMS = [
      :unique, :counter_cache, :class_name, :cache_class, :column_name
    ]

    ##
    # Deletes config_params and returns a hash of info ready
    # to be saved. i.e call save on model and pass this hash.
    #
    def create_statement
      _payload.tap do |payload|
        CONFIG_PARAMS.each { |key| payload.delete(key) }
      end
    end

  end
end
