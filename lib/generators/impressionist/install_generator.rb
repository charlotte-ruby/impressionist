module Impressionist
  module Generators
    class InstallGenerator < Rails::Generators::Base

    source_root File.expand_path('../../templates', __FILE__)

    desc "Creates an initializer called impressionist.rb\n
          which is used to add Minions to controllers\n
          ( i.e Save an impression for a determined controller )"

    hook_for :orm, as: :impressionist

    def copy_initializer
      template "impressionist.rb", "config/initializers/impressionist.rb"
    end

    end
  end
end
