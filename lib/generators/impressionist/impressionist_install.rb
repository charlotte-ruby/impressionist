module Impressionist
  module Generators
    class ImpressionistInstall < Rails::Generators::Base

    namespace "impressionist"
    source_root File.expand_path('../../templates', __FILE__)

    desc "Creates an initializer called impressionist.rb\n
          which is used to add Minions to controllers\n
          ( i.e Save an impression for a determined controller )"

    def copy_initializer
      template "impressionist.rb", "config/initializers/impressionist.rb"
    end

    end
  end
end
