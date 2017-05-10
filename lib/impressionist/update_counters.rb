# Note
# If impressionist_counter_cache_options[:counter_cache] is false(default)
# it won't even run this class
module Impressionist

  class UpdateCounters
    attr_reader :receiver, :klass

    def initialize(receiver)
      @receiver = receiver
      @klass = receiver.class
    end

    def update
      klass.
      update_counters(id, column_name => result)
    end

    private

    def result
      impressions_total - impressions_cached
    end

    # Count impressions based on unique_filter
    # default is :ip_address when unique: true
    def impressions_total
      receiver.impressionist_count filter
    end

    # Fetch impressions from a receiver's column
    def impressions_cached
      receiver.send(column_name) || 0
    end

    def filter
      {:filter => unique_filter}
    end

    # :filter gets assigned to :ip_address as default
    # One could do
    # is_impressionable :counter_cache => true,
    # :unique => :any_other_filter
    def unique_filter
      # Support `is_impressionable :counter_cache => true, :unique => true`
      # defaulting to `:ip_address` for counting unique impressions.
      return :ip_address if unique == true

      # Should a user try `is_impressionable :counter_cache => true, :unique => false`
      # then support that as well
      return :all if unique == false

      # Otherwise set the filter to either what the user supplied as the `unique` option
      # or the default (`:all`)
      unique
    end

    def unique
      cache_options[:unique]
    end

    def column_name
      cache_options[:column_name].to_s
    end

    def cache_options
      klass.
      impressionist_counter_cache_options
    end

    def id
      receiver.id
    end

  end

end
