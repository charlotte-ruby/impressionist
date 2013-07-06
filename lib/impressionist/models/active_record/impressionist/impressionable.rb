ActiveRecord::Base.send(:include, Impressionist::Impressionable)

module Impressionist
  module Impressionable
    extend ActiveSupport::Concern

    module ClassMethods

      def is_impressionable(options={})
        define_association

        @impressionist_cache_options = options
      end

private
      def define_association
        has_many(:impressions,
        :as => :impressionable,
        :dependent => :destroy)
      end

    end

  end

end
