module Impressionist
  module IsImpressionable
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
        :dependent => :delete_all)
      end
    end

  end
end
