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
      notifications.
        instrument("process_impression.impressionist", raw_payload) do |payload|
          append_to_imp_payload(payload)
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
        action: self.action_name,
        params: request.filtered_parameters,
        format: request.format.try(:ref),
        path:   (request.fullpath rescue "unknown"),
        status: response.status,
        user_agent: request.user_agent,
        ip_address: request.ip_address
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
    # impression is processed, returning its
    # payload ( i.e raw_payload ). So one can
    # add EXTRA information to be passed in
    # when impressionist subscribes to this
    # instrumentation in order to save an
    # impression.
    #
    # class Bottles < ApplicationController
    #
    #   def append_to_imp_payload(payload)
    #     payload[:extra_info]  = :here
    #     payload[:db_column]   = :here
    #   end
    # end
    #
    def append_to_imp_payload(payload); end


    def notifications
      @notifications ||= ::ActiveSupport::Notifications
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
      # This shifts burden to rails *_filter callbacks, instead of
      # having impressionist to 'parse' what actions an impression
      # should be saved for.
      #
      def set_impressionist_instrumentation
        self.after_filter(:imp_instrumentation, only: self.impressionable[:actions])
      end

    end

  end
  end
end
