source "https://rubygems.org"

gem "rake", ">= 13.1.0"
gem "rdoc", ">= 6.3.4"

gem "pry"
gem "rubocop", "~> 1.74", require: false
gem "rubocop-rake", "~> 0.7.1", require: false
gem "rubocop-rspec", "~> 3.5.0", require: false
gem "rubocop-rails", "~> 2.30.3", require: false
gem "rubocop-capybara", "~> 2.22.1", require: false
gem "rubocop-rspec_rails", "~> 2.31.0", require: false

platforms :jruby do
  gem 'activerecord-jdbcsqlite3-adapter'
  gem 'jdbc-sqlite3'
  gem 'jruby-openssl'
end

group :test do
  gem 'simplecov'
  gem 'systemu'
end

# Loads dependencies from impressionist.gemspec
# When you run `bundle install` inside the root of the gem, this command:
#   * Reads the .gemspec file
#   * Installs all gems listed with `add_dependency` and `add_development_dependency`
#   * Ensures the gem’s dependencies are managed through Bundler
gemspec
