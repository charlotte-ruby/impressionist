module ActiveRecord
  module Generators
    class ImpressionistGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.join(File.dirname(__FILE__), 'templates')

      def self.next_migration_number(dirname)
        next_number = current_migration_number(dirname) + 1
        if ActiveRecord.timestamped_migrations
          [Time.now.utc.strftime("%Y%m%d%H%M%S"), "%.14d" % next_number].max
        else
          "%.3d" % next_number
        end
      end

      def create_migration_file
        migration_template 'create_impressions_table.rb.erb', 'db/migrate/create_impressions_table.rb'
      end
    end
  end
end
