# Note
# It is only updatable if
# impressionist_id && impressionist_type(class) are present &&
# impressionable_class(which is imp_type.constantize) is counter_caching
# Defined like so
# is_impressionable :counter_cache => true

module Impressionist
  module CounterCache

    attr_reader :impressionable_class, :entity

    private

      # if updatable returns true, it must be qualified to update_counters
      # impressionable_class instance var is set when updatable? is called
      def impressionable_counter_cache_updatable?
         updatable? && impressionable_try
      end

      # asks imp_id && imp_class whether it's present or not
      # so that it is updatable
      def updatable?
        @impressionable_class = impressionable_class_set
        impressionable_valid?
      end

      def impressionable_valid?
        (self.impressionable_id.present? && impressionable_class)
      end

      def impressionable_find
        exeception_rescuer {
          @entity = impressionable_class.find(self.impressionable_id)
        }
        @entity

      end

      # imps_type == nil, constantize returns Object
      # It attemps to return false so it won't be updatable
      # calls to_s otherwise it would try to constantize nil
      # and it would raise an exeception
      # Must be !~ Object and be counter_caching to be qualified as updatable
      def impressionable_class_set
        klass = self.impressionable_type.to_s.constantize
        (klass.to_s !~ /Object/) && klass.impressionist_counter_caching? ? klass : false
      end

      # default mode is ERROR
      # ruby 1.8.7 support
      def impressionist_log(str, mode=:error)
        Rails.logger.send(mode.to_s, str)
      end

      # receives an entity(instance of a Model) and then tries to update
      # counter_cache column
      # entity is a impressionable instance model
      def impressionable_try
        impressionable_find
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
