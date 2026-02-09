require 'rubygems'
require 'bundler/setup'

if ENV['COVERAGE']
  require 'simplecov'
  require 'simplecov_json_formatter'
  SimpleCov.start do
    formatter SimpleCov::Formatter::JSONFormatter
    add_filter '/spec/'
  end
end

ENV['RAILS_ENV'] ||= 'test'

require_relative "dummy/config/environment"

require 'rails/all'
require 'rspec/rails'
# require 'capybara/rails'

require 'friendly_id'

ActiveRecord::Migrator.migrations_paths = [File.expand_path("../spec/dummy/db/migrate", __dir__)]

require "rails/test_help"

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.fixture_paths = ["spec/fixtures"]
  config.infer_spec_type_from_file_location!

  config.mock_with :rspec
  config.use_transactional_fixtures = true

  # excludes migration tag while running app base tests
  config.filter_run_excluding :migration => true

  # self explanatory
  # runs everything
  config.run_all_when_everything_filtered = true
end
