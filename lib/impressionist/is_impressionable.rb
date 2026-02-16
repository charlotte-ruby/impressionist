# frozen_string_literal: true

module Impressionist
  module IsImpressionable
    extend ActiveSupport::Concern

    module ClassMethods
      attr_accessor :impressionist_cache_options

      DEFAULT_CACHE = {
        counter_cache: false,
        column_name: :impressions_count,
        unique: :all
      }.freeze

      def is_impressionable(options = {})
        define_association
        @impressionist_cache_options = options

        true
      end

      def impressionist_counter_cache_options
        @impressionist_cache_options ||= {}
        @impressionist_cache_options.reverse_merge(DEFAULT_CACHE)
      end

      def impressionist_counter_caching?
        impressionist_counter_cache_options[:counter_cache]
      end

      private

      def define_association
        has_many :impressions,
                 as: :impressionable,
                 dependent: :delete_all
      end
    end

    # Instance methods - THIS WAS MISSING!
    def impressionable?
      true
    end

    def impressionist_count(options = {})
      options.reverse_merge!(filter: :request_hash, start_date: nil, end_date: Time.now)

      imps = if options[:start_date].blank?
               impressions
             else
               impressions.where('created_at >= ? and created_at <= ?', options[:start_date], options[:end_date])
             end

      imps = imps.where('impressions.message = ?', options[:message]) if options[:message]

      distinct = options[:filter] != :all
      if distinct
        imps.select(options[:filter]).distinct.count
      else
        imps.count
      end
    end

    def update_impressionist_counter_cache
      slave = Impressionist::UpdateCounters.new(self)
      slave.update
    end
  end
end