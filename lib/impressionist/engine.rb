require "impressionist"
require "rails"

module Impressionist
  class Engine < Rails::Engine
    attr_accessor :orm

  def initialize
    define_orm_type(Impressionist.orm)
  end

  initializer 'impressionist.model' do |app|
    require_and_include_orm

  end


  initializer 'impressionist.controller' do
    require "impressionist/controllers/mongoid/impressionist_controller.rb" if orm == :mongoid.to_s

    ActiveSupport.on_load(:action_controller) do
     include ImpressionistController::InstanceMethods
     extend ImpressionistController::ClassMethods
   end
  end


 private
  def require_and_include_orm
    require "#{root}/app/models/impressionist/impressionable.rb"
    require "impressionist/models/#{orm}/impression.rb"
    require "impressionist/models/#{orm}/impressionist/impressionable.rb"

  end

  def define_orm_type(str)
    @orm = matcher(str.to_s)
  end

  def matcher(str)
    matched = str.match(/active_record|mongo_mapper|mongoid|/)
    matched[0]
  end


  end
end
