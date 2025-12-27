# frozen_string_literal: true

module Impressionist
  class UpdateCounters
    attr_reader :receiver, :klass

    def initialize(receiver)
      @receiver = receiver
      @klass = receiver.class
    end

    def update
      return unless valid_update?

      klass.update_counters(id, column_name => result)
    end

    private

    def valid_update?
      receiver.present? &&
        klass.respond_to?(:update_counters) &&
        column_name.present? &&
        klass.column_names.include?(column_name)
    end

    def result
      impressions_total - impressions_cached
    end

    def impressions_total
      receiver.impressionist_count(filter)
    end

    def impressions_cached
      receiver.send(column_name) || 0
    end

    def filter
      { filter: unique_filter }
    end

    def unique_filter
      return :ip_address if unique == true
      return :all if unique == false

      unique
    end

    def unique
      cache_options[:unique]
    end

    def column_name
      cache_options[:column_name].to_s
    end

    def cache_options
      klass.impressionist_counter_cache_options
    end

    def id
      receiver.id
    end
  end
end