require 'minitest_helper'
require 'rails/generators'
require 'rails/generators/active_record'
require 'generators/impressionist/impressionist_generator'

class ImpressionistGeneratorTest < Rails::Generators::TestCase

  destination File.expand_path('../../../tmp', __FILE__)

  tests Impressionist::Generators::ImpressionistGenerator

  setup :prepare_destination

  test "must install impressionist" do
    run_generator %w{ impressionist:install }

    assert_file "config/initializers/impressionist.rb"
  end

  test "must create a migration" do
    run_generator %w{ impressionist:install --orm=active_record }

    assert_migration "db/migrate/impressionist_create_impressions.rb"
  end

  test "must create an initializer with a different orm" do
    run_generator %w{ impressionist:install --orm=mongoid }

    assert_file "config/initializers/impressionist.rb", /Impressionist::ORM.orm = :mongoid/
  end


end
