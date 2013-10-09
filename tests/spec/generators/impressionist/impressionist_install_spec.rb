require 'minitest_helper'
require 'rails/generators'
require 'generators/impressionist/impressionist_install'

class ImpressionistInstallTest < Rails::Generators::TestCase

  tests Impressionist::Generators::ImpressionistInstall
  destination File.expand_path('../../tmp', __FILE__)

  test "must create config/initializers/impressionist.rb" do
    run_generator %w{ impressionist:install }
    assert_file "config/initializers/impressionist.rb"
  end

end
