module Impressionist
  class Engine < ::Rails::Engine
    attr_accessor :orm

  initializer 'impressionist.model' do |app|
    @orm = Impressionist.orm
    include_orm
  end


  initializer 'impressionist.controller' do
    require "impressionist/controllers/mongoid/impressionist_controller.rb" if orm == :mongoid.to_s

    ActiveSupport.on_load(:action_controller) do
     include ImpressionistController::InstanceMethods
     extend ImpressionistController::ClassMethods
   end
  end


 private

    def include_orm
      require "#{root}/app/models/impressionist/impressionable.rb"
      require "impressionist/models/#{orm}/impression.rb"
      require "impressionist/models/#{orm}/impressionist/impressionable.rb"
    end

  end
end
