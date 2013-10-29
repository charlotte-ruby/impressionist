require 'minitest_helper'
require 'rails/generators'
require 'rails/generators/active_record'
require 'generators/active_record/impressionist_generator'

class ActiveRecordGeneratorTest < Rails::Generators::TestCase
  tests ActiveRecord::Generators::ImpressionistGenerator

  destination File.expand_path('../../../tmp', __FILE__)

  setup :prepare_destination

  test "must copy impressioin's migration file" do
    run_generator
    assert_migration "db/migrate/create_impressions_table.rb"
  end

  test "must copy impressionscache's migration file" do
    run_generator
    assert_migration "db/migrate/create_impressions_cache_table"
  end

end
