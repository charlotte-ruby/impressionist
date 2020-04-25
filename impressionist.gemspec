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
  if s.respond_to? :required_rubygems_version=
    s.required_rubygems_version = Gem::Requirement.new('>= 1.3.6')
  end

  s.add_dependency 'nokogiri', RUBY_VERSION < '2.1.0' ? '~> 1.6.0' : '~> 1'
  s.add_dependency 'rails', '>= 3.2.15'
  s.add_development_dependency 'bundler', '~> 2.0'
  s.add_development_dependency 'sqlite3', '~> 1.4'
end
