ENV["RAILS_ENV"] ||= 'test'

unless ENV['CI']
  require 'simplecov'
  SimpleCov.start 'rails'
end

require File.
expand_path("../../config/environment", __FILE__)

require 'rspec/rails'
require 'capybara/rails'

# Custom matchers and macros, etc...
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f|
  require f
}

RSpec.configure do |config|
  config.mock_with :rspec

  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.use_transactional_fixtures = true

  # make the rails logger usable in the tests as logger.xxx "..."
  def logger
    Rails.logger
  end

end
