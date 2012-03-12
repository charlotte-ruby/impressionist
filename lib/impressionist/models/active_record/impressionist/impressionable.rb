module Impressionist
  module Impressionable
    extend ActiveSupport::Concern

    module ClassMethods
      def is_impressionable(options={})
        has_many :impressions, :as => :impressionable, :dependent => :destroy
        @cache_options = options[:counter_cache]
      end
    end
  end
end
