module Impressionist
  module Impressionable
    extend ActiveSupport::Concern

    module ClassMethods
      def is_impressionable(options={})
      	has_many :impressions, as: :impressionable, dependent: :destroy
        	@impressionist_cache_options = options[:counter_cache]
        	if !@impressionist_cache_options.nil?
        		opts = impressionist_counter_cache_options
        		field opts[:column_name], type: Integer
        	end
      end

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
      imps = options[:start_date].blank? ? impressions : impressions.between(created_at: options[:start_date]..options[:end_date])
      options[:filter] == :all ? imps.count : imps.where(options[:filter].ne => nil).count
    end

    def update_impressionist_counter_cache
      cache_options = self.class.impressionist_counter_cache_options
      column_name = cache_options[:column_name].to_sym
      count = cache_options[:unique] ? impressionist_count(:filter => :ip_address) : impressionist_count
      old_count = send(column_name) || 0
      self.inc(column_name, (count - old_count))
    end

  end
end