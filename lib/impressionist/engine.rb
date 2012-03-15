require "impressionist"
require "rails"

module Impressionist
  class Engine < Rails::Engine
    initializer 'impressionist.model' do |app|
      require "#{root}/app/models/impressionist/impressionable.rb"
      if Impressionist.orm == :active_record
        require "impressionist/models/active_record/impression.rb"
        require "impressionist/models/active_record/impressionist/impressionable.rb"
        ActiveRecord::Base.send(:include, Impressionist::Impressionable)
      elsif Impressionist.orm == :mongo_mapper
        require "impressionist/models/mongo_mapper/impression.rb"
        require "impressionist/models/mongo_mapper/impressionist/impressionable.rb"
        MongoMapper::Document.plugin Impressionist::Impressionable
      end
    end

    initializer 'impressionist.controller' do
      ActiveSupport.on_load(:action_controller) do
        include ImpressionistController::InstanceMethods
        extend ImpressionistController::ClassMethods
      end
    end
  end
end
