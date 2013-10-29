module ActiveRecord
  module Generators
    class ImpressionistGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      class << self

        def set_next_migration(migration_number)
          mr_migrator.next_migration_number(migration_number)
        end

        def next_migration_number(dirname)
          set_next_migration current_migration_number(dirname) + 1
        end

        def mr_migrator 
          ActiveRecord::Migration
        end

        private(:set_next_migration, :mr_migrator)
      end

      source_root File.expand_path('../templates', __FILE__)
      
      def copy_impressionist_migration
        migration_template "migration.rb", "db/migrate/create_impressions_table.rb"
      end

      def copy_impressions_cache_migration
        migration_template "impressions_cache_migration.rb", "db/migrate/create_impressions_cache_table.rb"
      end

    end
  end
end
