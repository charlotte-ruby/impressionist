module Impressionist
  module Impressionable
    extend ActiveSupport::Concern

    module ClassMethods
      def is_impressionable(options={})
        many :impressions, :as => :impressionable, :dependent => :destroy
        @cache_options = options[:counter_cache]
      end
    end
  end
end
