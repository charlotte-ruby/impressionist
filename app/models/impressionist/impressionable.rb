module Impressionist
  module Impressionable
    extend ActiveSupport::Concern

    module ClassMethods
      attr_accessor :impressionist_cache_options
      @impressionist_cache_options = nil

      def impressionist_counter_cache_options
        if @impressionist_cache_options
          options = { :column_name => :impressions_count, :unique => false }
          options.merge!(@impressionist_cache_options) if @impressionist_cache_options.is_a?(Hash)
          options
        end
      end

      def impressionist_counter_caching?
        impressionist_counter_cache_options.present?
      end

      def counter_caching?
        ::ActiveSupport::Deprecation.warn("#counter_caching? is deprecated; please use #impressionist_counter_caching? instead")
        impressionist_counter_caching?
      end
    end

    def impressionable?
      true
    end

    def impressionist_count(options={})
      options.reverse_merge!(:filter=>:request_hash, :start_date=>nil, :end_date=>Time.now)
      imps = options[:start_date].blank? ? impressions : impressions.where("created_at>=? and created_at<=?",options[:start_date],options[:end_date])
      options[:filter] == :all ? imps.count : imps.count(options[:filter], :distinct => true)
    end

    def update_impressionist_counter_cache
      cache_options = self.class.impressionist_counter_cache_options
      column_name = cache_options[:column_name].to_sym
      count = cache_options[:unique] ? impressionist_count(:filter => :ip_address) : impressionist_count
      old_count = send(column_name) || 0
      self.class.update_counters(id, column_name => (count - old_count))
    end

    # OLD METHODS - DEPRECATE IN V0.5
    def impression_count(start_date=nil,end_date=Time.now)
      impressionist_count({:start_date=>start_date, :end_date=>end_date, :filter=>:all})
    end

    def unique_impression_count(start_date=nil,end_date=Time.now)
      impressionist_count({:start_date=>start_date, :end_date=>end_date, :filter=> :request_hash})
    end

    def unique_impression_count_ip(start_date=nil,end_date=Time.now)
      impressionist_count({:start_date=>start_date, :end_date=>end_date, :filter=> :ip_address})
    end

    def unique_impression_count_session(start_date=nil,end_date=Time.now)
      impressionist_count({:start_date=>start_date, :end_date=>end_date, :filter=> :session_hash})
    end
  end
end
