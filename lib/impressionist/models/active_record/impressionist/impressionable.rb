ActiveRecord::Base.send(:include, Impressionist::Impressionable)

module Impressionist
  module Impressionable

    extend ActiveSupport::Concern

    module ClassMethods
      def is_impressionable(options={})
        define_association
        imp_cache_options_set(options)
      end

      def define_association
        has_many(:impressions,
        :as => :impressionable,
        :dependent => :destroy)
      end

      def imp_cache_options_set(options)
        @impressionist_cache_options = options
      end

    end

  end

end
