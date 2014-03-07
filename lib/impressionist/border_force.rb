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
      valid_to_save? and model.save_impression create_savable_hash
    end

    def savable?
      valid_to_save? and yield
    end

    def valid_to_save?
      _user_agent_checker.valid?(user_agent) and unique?
    end

    #
    # Returns false if impression exists based on unique filter,
    # otherwise true.
    #
    def unique?
      not(!unique.empty? and model.impression_exist?(get_unique_filters))
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
    def get_unique_filters
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
    def create_savable_hash
      _payload.tap do |payload|
        CONFIG_PARAMS.each { |key| payload.delete(key) }
      end
    end

  end
end
