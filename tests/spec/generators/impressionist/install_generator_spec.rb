require 'minitest_helper'
require 'rails/generators'
require 'generators/impressionist/install_generator'

class InstallGeneratorTest < Rails::Generators::TestCase

  setup do
    prepare_destination
  end

  tests Impressionist::Generators::InstallGenerator
  destination File.expand_path('../../tmp', __FILE__)

  FILE_PATH = "config/initializers/impressionist.rb"
  test "must create config/initializers/impressionist.rb" do
    run_generator %w{ impressionist:install }
    assert_file FILE_PATH
  end

  test "must be able to add minions" do
    run_generator
    assert_file FILE_PATH, /Impressionist::Minion::MinionCreator/
  end

  test "must show rationale" do
    run_generator
    assert_file FILE_PATH, /# add\(:posts, :index, :edit\)/
  end

  test "must create with a different orm" do
    run_generator %w{ impressionist:install --orm mongoid }
    assert_file FILE_PATH, /:mongoid/
  end

end
