# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
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
  s.required_rubygems_version = Gem::Requirement.new('>= 1.3.6') if s.respond_to? :required_rubygems_version=

  s.add_development_dependency 'rake', '>= 0.9'
  s.add_development_dependency 'rack'
  s.add_development_dependency 'rails', '~> 4.0.0'
  s.add_development_dependency 'rdoc', '>= 2.4.2'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'pg'
  s.add_development_dependency 'systemu'
  s.add_development_dependency 'minitest', '4.2'
end
