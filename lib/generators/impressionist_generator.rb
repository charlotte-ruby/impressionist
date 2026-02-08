module Impressionist
  module Generators
    class ImpressionistGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path('../templates', __FILE__)

      def copy_config_file
        template 'impression.rb.erb', 'config/initializers/impression.rb'
      end

      def create_migration_file
        migration_template 'create_impressions_table.rb.erb', 'db/migrate/create_impressions_table.rb'
      end
    end
  end
end
