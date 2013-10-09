require 'minitest_helper'
require 'rails/generators'
require 'generators/impressionist/install_generator'

class InstallGeneratorTest < Rails::Generators::TestCase

  setup :prepare_destination

  tests Impressionist::Generators::InstallGenerator
  destination File.expand_path('../../tmp', __FILE__)

  FILE_PATH = "config/initializers/impressionist.rb"

  test "must create config/initializers/impressionist.rb" do
    run_generator %w{ impressionist:install }
    assert_file FILE_PATH
  end

  test "must create with a different orm" do
    run_generator %w{ impressionist:install --orm=mongoid }
    assert_file FILE_PATH, /:mongoid/
  end

end
