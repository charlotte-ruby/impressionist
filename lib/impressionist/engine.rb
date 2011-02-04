require "impressionist"
require "rails"

module Impressionist
  class Engine < Rails::Engine
    
    initializer 'impressionist.controller' do
      ActiveSupport.on_load(:action_controller) do
         include ImpressionistController::InstanceMethods
         extend ImpressionistController::ClassMethods
      end
    end
    
    initializer 'impressionist.extend_ar' do
      ActiveRecord::Base.extend Impressionist::Impressionable
    end
  end
end