module Impressionist
  module CounterCache

    attr_reader :impressionable_class, :entity

    private

      # A valid impression must
      # have a valid impressionable class
      # be counter_caching
      # have a record saved in the db
      # then it should give it a try
      def impressionable_counter_cache_updatable?
        updatable? && impressionable_try
      end

      def updatable?
        valid_impressionable_class? && impressionable_find
      end

      def valid_impressionable_class?
        set_impressionable_class && counter_caching?
      end

      def set_impressionable_class
        klass = self.impressionable_type  || false
        @impressionable_class = klass.
          to_s.safe_constantize           || false
      end

      def impressionist_log(str, mode=:error)
        Rails.logger.send(mode.to_s, str)
      end

      # receives an entity(instance of a Model) and then tries to update
      # counter_cache column
      # entity is a impressionable instance model
      def impressionable_try
        entity.try(:update_impressionist_counter_cache)
      end

      def impressionable_find
        exeception_rescuer {
          @entity = impressionable_class.find(self.impressionable_id)
        }
        @entity

      end

      def counter_caching?
        impressionable_class.
          impressionist_counter_caching?
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
