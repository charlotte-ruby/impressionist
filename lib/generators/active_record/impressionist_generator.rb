module ActiveRecord
  module Generators
    class ImpressionistGenerator < ActiveRecord::Generators::Base

      source_root File.expand_path('../templates', __FILE__)

      def copy_impressionist_migration
        migration_template "migration.rb", "db/migrate/impressionist_create_impressions.rb"
      end

    end
  end
end
