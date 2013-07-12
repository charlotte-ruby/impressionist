# TODO: Refactor this Entity
# There's a lot of duplication
Mongoid::Document.send(:include, Impressionist::Impressionable)

module Impressionist
  module Impressionable
    extend ActiveSupport::Concern

    module ClassMethods

      def is_impressionable(options={})
        define_association
        @impressionist_cache_options = options

        true
      end

        private
          def define_association
            has_many(:impressions,
            :as => :impressionable,
            :dependent => :destroy)
          end

    end

    ##
    # Overides active_record impressionist_count
    def impressionist_count(options={})
      options.reverse_merge!(:filter=>:request_hash, :start_date=>nil, :end_date=>Time.now)
      imps = options[:start_date].blank? ? impressions : impressions.between(created_at: options[:start_date]..options[:end_date])
      filter = options[:filter]
      filter == :all ? imps.count : imps.where(filter.ne => nil).distinct(filter).count
    end

  end

end
