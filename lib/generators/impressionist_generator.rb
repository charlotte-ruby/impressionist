module Impressionist
  module Generators
    class ImpressionistGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path('../templates', __FILE__)

      def self.next_migration_number(*)
        format = if Rails.application.config.generators.respond_to?(:migration_number_format)
                   Rails.application.config.generators.migration_number_format
                 else
                   "%Y%m%d%H%M%S"
                 end

        Time.now.utc.strftime(format)
      end

      def copy_config_file
        template 'impression.rb.erb', 'config/initializers/impression.rb'
      end

      def create_migration_file
        if defined?(ActiveRecord::Base) && ActiveRecord::Base.respond_to?(:connection)
          migration_template 'create_impressions_table.rb.erb', 'db/migrate/create_impressions_table.rb'
        else
          say_status :skip, "Skipping ActiveRecord migration"
          say "If you're using Mongoid or MongoMapper, set config.orm = :mongoid (or :mongo_mapper) in config/initializers/impression.rb"
        end
      end
    end
  end
end
