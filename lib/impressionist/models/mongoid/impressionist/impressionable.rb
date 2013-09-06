module Impressionist
  module Impressionable

  # extends AS::Concern
  include Impressionist::IsImpressionable

    ## TODO: Make it readable

    # Overides impressionist_count in order to provied
    # mongoid compability
    def impressionist_count(options={})
      options.
      reverse_merge!(
        :filter=>:request_hash,
        :start_date=>nil,
        :end_date=>Time.now)

      imps = options[:start_date].blank?
        ? impressions :
        impressions.
          between(created_at: options[:start_date]..options[:end_date])

      filter = options[:filter]

      filter == :all ?
        imps.count :
        imps.where(filter.ne => nil).
          distinct(filter).count
    end

  end
end

Mongoid::Document.
send(:include, Impressionist::Impressionable)
