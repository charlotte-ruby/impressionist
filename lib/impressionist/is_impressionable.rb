module Impressionist
  module IsImpressionable
    extend ActiveSupport::Concern

    module ClassMethods

      def is_impressionable(options={})
        @impressionist_cache_options = options
        dependent_destroy = options.fetch(:dependent_destroy, true)

        define_association(dependent_destroy)
        true
      end

      private

      def define_association(dependent_destroy)
        assoc_options = {:as => :impressionable, :dependent => :destroy}
        assoc_options.delete(:dependent) if !dependent_destroy

        has_many(:impressions, assoc_options)
      end
    end
  
  end
end
