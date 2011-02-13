require "impressionist"
require "rails"

module Impressionist
  class Engine < Rails::Engine    
    initializer 'impressionist.extend_ar' do |app|
      ActiveRecord::Base.extend Impressionist::Impressionable
    end
    
    initializer 'impressionist.controller' do
      ActiveSupport.on_load(:action_controller) do
        include ImpressionistController::InstanceMethods
        extend ImpressionistController::ClassMethods
      end
    end
  end
end