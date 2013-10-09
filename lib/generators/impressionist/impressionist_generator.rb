module Impressionist
  module Generators
    class ImpressionistGenerator < Rails::Generators::Base

      namespace "impressionist"
      source_root File.expand_path('../../templates', __FILE__)

      desc "Generates an initializer file called impressionist.rb plus an impressionist migration file."

      hook_for :orm

      def copy_all_files
        template "impressionist.rb", "config/initializers/impressionist.rb"
      end


    end
  end
end
