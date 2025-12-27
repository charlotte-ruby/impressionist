# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'impressionist/version'

Gem::Specification.new do |s|
  s.name          = 'impressionist'
  s.platform      = Gem::Platform::RUBY
  s.version = Impressionist::VERSION
  s.required_ruby_version = '>= 3.0'
  s.add_dependency 'rails', '>= 6.0'
  s.licenses      = ['MIT']
  s.summary       = 'Easy way to log impressions'
  s.email         = 'john.mcaliley@gmail.com'
  s.homepage      = 'http://github.com/charlotte-ruby/impressionist'
  s.description   = 'Log impressions from controller actions or from a model'
  s.authors       = ['johnmcaliley']

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- tests/**/*`.split("\n")
  s.require_path  = 'lib'

  s.add_dependency "friendly_id"
  s.add_dependency 'nokogiri', RUBY_VERSION < '2.1.0' ? '~> 1.6.0' : '~> 1'

  s.add_development_dependency 'bundler', '~> 2.0'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'sqlite3', '~> 1.4'
end
