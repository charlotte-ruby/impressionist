# frozen_string_literal: false

ENV['RAILS_ENV'] ||= 'test'

unless ENV['CI']
  require 'simplecov'
  SimpleCov.start 'rails'
end

require File.expand_path('../config/environment', __dir__)

# ActiveRecord::Migration.maintain_test_schema!
# load File.expand_path('../db/schema.rb', __dir__)

require 'rspec/rails'
require 'capybara/rails'

# Custom matchers and macros, etc...
Dir[Rails.root.join('spec/support/**/*.rb')].sort.each do |f|
  require f
end

RSpec.configure do |config|
  # in order to pass tags(symbols) as true values
  # you need to tell rspec to do so by
  config.infer_spec_type_from_file_location!
  config.treat_symbols_as_metadata_keys_with_true_values = true

  config.mock_with :rspec

  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.use_transactional_fixtures = true

  # excludes migration tag while running app base tests
  config.filter_run_excluding migration: true

  # self explanatory
  # runs everything
  config.run_all_when_everything_filtered = true

  # make the rails logger usable in the tests as logger.xxx "..."
  def logger
    Rails.logger
  end
end
