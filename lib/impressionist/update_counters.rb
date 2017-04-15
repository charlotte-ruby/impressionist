# Note
# If impressionist_counter_cache_options[:counter_cache] is false(default)
# it won't even run this class
module Impressionist

  class UpdateCounters
    attr_reader :impressionable, :receiver, :receiver_column_name

    def initialize(impressionable)
      @impressionable = impressionable

      @receiver = @impressionable
      @receiver_column_name = column_name
      while @receiver_column_name.instance_of? Hash do
        key = @receiver_column_name.keys.first
        @receiver = @receiver.send(key)
        @receiver_column_name = @receiver_column_name[key]
      end
    end

    def update
      receiver.class.
      update_counters(id, receiver_column_name => result)
    end

    private

    def result
      impressions_total - impressions_cached
    end

    # Count impressions based on unique_filter
    # default is :ip_address when unique: true
    def impressions_total
      impressionable.impressionist_count filter
    end

    # Fetch impressions from a receiver's column
    def impressions_cached
      receiver.send(receiver_column_name) || 0
    end

    def filter
      {:filter => unique_filter}
    end

    # :filter gets assigned to :ip_address as default
    # One could do
    # is_impressionable :counter_cache => true,
    # :unique => :any_other_filter
    def unique_filter
      Symbol === unique ?
      unique :
      :ip_address
    end

    def unique
      cache_options[:unique]
    end

    def column_name
      cache_options[:column_name]
    end

    def cache_options
      impressionable.class.
      impressionist_counter_cache_options
    end

    def id
      receiver.id
    end

  end

end
