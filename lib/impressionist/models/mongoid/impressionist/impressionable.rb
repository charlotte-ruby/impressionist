module Impressionist
  module Impressionable

  # extends AS::Concern
  include Impressionist::IsImpressionable

    # Overides impressionist_count in order to provide mongoid compability
    def impressionist_count(options={})

      # Uses these options as defaults unless overridden in options hash
      options.reverse_merge!(:filter => :request_hash, :start_date => nil, :end_date => Time.now)

      # If a start_date is provided, finds impressions between then and the end_date.
      # Otherwise returns all impressions
      imps = options[:start_date].blank? ? impressions :
        impressions.between(created_at: options[:start_date]..options[:end_date])


      # Count all distinct impressions unless the :all filter is provided
      distinct = options[:filter] != :all
      distinct ? imps.where(options[:filter].ne => nil).distinct(options[:filter]).count : imps.count
    end

  end
end

Mongoid::Document.
send(:include, Impressionist::Impressionable)
