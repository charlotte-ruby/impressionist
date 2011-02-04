require "impressionist"
require "rails"

module Impressionist
  class Engine < Rails::Engine    
    initializer 'impressionist.extend_ar' do
      ActiveRecord::Base.extend Impressionist::Impressionable
    end
  end
end