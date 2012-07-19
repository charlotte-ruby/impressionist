module Impressionist
  module Generators
    class ImpressionistGenerator < Rails::Generators::Base
      hook_for :orm
      source_root File.expand_path('../templates', __FILE__)

      def copy_config_file
        template 'impression.rb', 'config/initializers/impression.rb'
      end

    end
  end
end
