module Impressionist
  module Impressionable
    extend ActiveSupport::Concern

    module ClassMethods
      attr_accessor :impressionist_cache_options

      DEFAULT_CACHE = { :counter_cache => false, :column_name => :impressions_count, :unique => false }

      def impressionist_counter_cache_options
        @impressionist_cache_options ||= {}
        @impressionist_cache_options.reverse_merge!(DEFAULT_CACHE)
      end

      # asks impressionable entity whether or not it is counter_caching
      def impressionist_counter_caching?
        impressionist_counter_cache_options[:counter_cache]
      end

      def counter_caching?
          ::ActiveSupport::Deprecation.warn("#counter_caching? is deprecated; please use #impressionist_counter_caching? instead")
          impressionist_counter_caching?
      end

    end # end of ClassMethods

    # ------------------------------------------
    # TODO: CLEAN UP, make it HUMAN readable
    def impressionist_count(options={})
      options.reverse_merge!(:filter=>:request_hash, :start_date=>nil, :end_date=>Time.now)
      imps = options[:start_date].blank? ? impressions : impressions.where("created_at>=? and created_at<=?",options[:start_date],options[:end_date])
      options[:filter] == :all ? imps.count : imps.count(options[:filter], :distinct => true)
    end

    def update_impressionist_counter_cache
      slave = Impressionist::UpdateCounters.new(self)
      slave.update
    end

    def impressionable?
      true
    end

  end

end
