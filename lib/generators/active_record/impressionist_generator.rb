module ActiveRecord
  module Generators
    class ImpressionistGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      source_root File.join(File.dirname(__FILE__), 'templates')

      def self.next_migration_number(dirname)
        sleep 1
        if ActiveRecord::Base.timestamped_migrations
          Time.now.utc.strftime("%Y%m%d%H%M%S")
        else
          "%.3d" % (current_migration_number(dirname) + 1)
        end
      end

      def create_migration_file
        migration_template 'create_impressions_table.rb', 'db/migrate/create_impressions_table.rb'
      end

      def create_hstore_migration_file
        if gem_available?('pg')
          if yes?("Would you like to add activerecord-postgres-hstore support?")
            gem("activerecord-postgres-hstore")
            generate("hstore:setup")
            migration_template 'add_params_to_impressions_table.rb', 'db/migrate/add_params_to_impressions_table.rb'
          end
        end
      end

      private

      def gem_available?(name)
         Gem::Specification.find_by_name(name)
      rescue Gem::LoadError
         false
      rescue
         Gem.available?(name)
      end
    end
  end
end
