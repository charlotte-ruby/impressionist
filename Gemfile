source 'https://rubygems.org'

gem 'rake', '>= 0.9'
gem 'rdoc', '>= 2.4.2'

platforms :jruby do
  gem 'activerecord-jdbcsqlite3-adapter'
  gem 'jdbc-sqlite3'
  gem 'jruby-openssl'
end

group :test do
  gem 'minitest'
  gem 'rspec', "~> 3.0"
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'simplecov'
  gem 'systemu'
end

gemspec