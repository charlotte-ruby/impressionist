module Impressionist
  module CounterCache

    attr_reader :impressionable_class, :entity

    private
      LOG_MESSAGE = "Can't find impressionable_type or impressionable_id. Will not update_counters!"

      # if updatable returns true, it must be qualified to update_counters
      # Therefore there's no need to validate again
      # impressionable_class instance var is set when updatable? is called
      def impressionable_counter_cache_updatable?
        updatable? ? update_impression_cache : impressionist_log(LOG_MESSAGE)
      end

      def update_impression_cache
        impressionable_find
        impressionable_try
      end

      # asks imp_id whether it's present or not
      # also expect imp_class to be true
      # all should be true, so that it is updatable
      def updatable?
        @impressionable_class = impressionable_class_set
        impressionable_valid?
      end

      # imps_type == nil, constantize returns Object
      # Therefore it attemps to return false so it won't be updatable
      # calls to_s otherwise it would try to constantize nil
      # and it would raise an exeception..
      def impressionable_class_set
        _type_ = self.impressionable_type.to_s.constantize
        ((_type_.to_s !~ /Object/) && _type_.impressionist_counter_caching? ? _type_ : false)
      end

      # Either true or false
      # needs true to be updatable
      def impressionable_valid?
        (self.impressionable_id.present? && impressionable_class && impressionable_find)
      end

      # Logs to log file, expects a message to be passed

      # default mode is ERROR
      # ruby 1.8.7 support
      def impressionist_log(str, mode=:error)
        Rails.logger.send(mode.to_s, str)
      end

      # read it out and LOUD
      def impressionable_find
        exeception_rescuer {
          @entity = impressionable_class.find(self.impressionable_id)
        }
        @entity

      end

      # receives an entity(instance of a Model) and then tries to update
      # counter_cache column
      # entity is a impressionable_model
      def impressionable_try
        entity.try(:update_impressionist_counter_cache)
      end

      # Returns false, as it is only handling one exeception
      # It would make updatable to fail thereafter it would not try
      # to update cache_counter
      def exeception_rescuer
          begin
            yield
          rescue ActiveRecord::RecordNotFound
            exeception_to_log
            false
          end
      end

      def exeception_to_log
        impressionist_log("Couldn't find Widget with id=#{self.impressionable_id}")
      end

  end
end
