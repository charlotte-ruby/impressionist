module Impressionist
  module Minion
  module Instrumentation
  extend ActiveSupport::Concern

    private

    def imp_instrumentation
      notifications.
        instrument("process_impression.impressionist", raw_payload)
    end

    ##
    # Creates a payload to be instrumented for a particular
    # minion, merges results from impressionable method.
    # This hash_of_info is pretty much the same as
    # actionpack/lib/action_controller/metal/instrumentation#18
    def raw_payload
      {
        action: self.action_name,
        params: request.filtered_parameters,
        format: request.format.try(:ref),
        path:   (request.fullpath rescue "unknown"),
        status: response.status
      }.merge(get_impressionable)
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
    def get_impressionable
      self.class.impressionable
    end


    def notifications
      @notifications ||= ActiveSupport::Notifications
    end

    module ClassMethods

      private
      ##
      # Responsible for adding a instrumentation
      # to a given controller. It gathers actions
      # from impressionable method, which is defined
      # when a minion is added.
      def set_impressionist_instrumentation
        self.after_filter(:imp_instrumentation, only: self.impressionable[:actions])
      end

    end

  end
  end
end
