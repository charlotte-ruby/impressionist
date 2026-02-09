source 'https://rubygems.org'

gem 'rake', '>= 12.3.3'
gem 'rdoc', '>= 2.4.2'

platforms :jruby do
  gem 'activerecord-jdbcsqlite3-adapter'
  gem 'jdbc-sqlite3'
  gem 'jruby-openssl'
end

group :test do
  gem 'capybara', '~> 3.40'
  gem 'minitest'
  gem 'pry'
  gem 'rspec', "~> 3.0"
  gem 'rspec-rails', '~> 8.0'
  gem 'rubocop-rails', require: false
  gem 'rubocop-rake', require: false
  gem 'rubocop-rspec', require: false
  gem 'simplecov'
  gem 'simplecov_json_formatter'
  gem 'sqlite3', '~> 2.9'
  gem 'systemu'
end

gemspec
