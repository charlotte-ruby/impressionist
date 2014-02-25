module Impressionist
  module Minion
  module Instrumentation
  extend ActiveSupport::Concern

    private

    ##
    # Instruments a notification with information
    # such as user_agent, ip_address, etc...
    #
    def imp_instrumentation
      notifier.
        instrument("process_impression.impressionist", raw_payload) do |payload|
          append_to_imp_payload(payload[:extra])
        end
    end

    ##
    # Creates a payload to be instrumented for a particular
    # minion, merges results from impressionable method.
    # This hash_of_info is pretty much the same as
    # actionpack/lib/action_controller/metal/instrumentation#18
    #
    def raw_payload
      {
        action:     self.action_name,
        params:     request.filtered_parameters,
        format:     request.format.try(:ref),
        path:       (request.fullpath rescue "unknown"),
        status:     response.status,
        user_agent: request.user_agent,
        ip_address: request.remote_ip,
        extra:      {}
      }.merge(impressionable_hash)
    end

    ##
    # When a minion is added
    # add(:peppa, :index, ... )
    # It creates a method called #impressionable
    # in the class object. ( PeppaController )
    # get_impressionable is responsible for
    # getting this method, which is a hash of
    # important params, such as actions to save impressions
    # for, to be able to save an impression.
    # check out impressionist/minion/methods#generate_hash
    #
    def impressionable_hash
      self.class.impressionable
    end

    ##
    # This method is invoked everytime an
    # impression is processed, returning an
    # empty hash whose key is :extra.
    # So one can add EXTRA information to be passed in.
    #
    # class BottlesController < ApplicationController
    #
    #   def append_to_imp_payload(payload)
    #     payload[:extra_info]  = :here
    #     payload[:db_column]   = :here
    #   end
    # end
    #
    # => { payload... extra: { extra_info: :here, db_column: :here } }
    #
    # TODO: Change this to yield a block whose argument is self itself.
    def append_to_imp_payload(payload); end


    def notifier
      @notifier ||= ::ActiveSupport::Notifications
    end

    module ClassMethods

      private
      ##
      # Adds an instrumentation to a given controller.
      # It gathers information from impressionable method,
      # which is defined when a minion is added.
      # It is just a *_filter rails hook.
      #
      # self.impressionable[:actions] are the actions defined
      # when creating a new minion.
      #
      def set_impressionist_instrumentation
        hook    = "#{self.impressionable[:hook]}_action"
        actions = self.impressionable[:actions]
        self.send(hook, :imp_instrumentation, only: actions)
      end

    end

  end
  end
end
