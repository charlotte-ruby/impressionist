# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'impressionist/version'

Gem::Specification.new do |s|
  s.name          = 'impressionist'
  s.version       = Impressionist::VERSION.dup
  s.platform      = Gem::Platform::RUBY
  s.licenses      = ['MIT']
  s.summary       = 'Easy way to log impressions'
  s.email         = 'john.mcaliley@gmail.com'
  s.homepage      = 'http://github.com/charlotte-ruby/impressionist'
  s.description   = 'Log impressions from controller actions or from a model'
  s.authors       = ['johnmcaliley']

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- tests/**/*`.split("\n")
  s.require_path  = 'lib'

  s.add_dependency "friendly_id", '~> 5.6'
  s.add_dependency 'nokogiri', '~> 1.19'
  s.add_dependency 'rails', '>= 3.2.15'

  s.add_development_dependency 'capybara', '~> 3.40'
  s.add_development_dependency 'rspec-rails', '~> 8.0'
  s.add_development_dependency 'sqlite3', '~> 2.9'
end
