MongoMapper::Document.plugin Impressionist::Impressionable

module Impressionist
  module Impressionable
    extend ActiveSupport::Concern

    module ClassMethods

        def is_impressionable(options={})
          many(:impressions,
          :as => :impressionable,
          :dependent => :delete_all)

          @impressionist_cache_options = options
        end

    end

  end

end
