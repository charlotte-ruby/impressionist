# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'impressionist/version'

Gem::Specification.new do |s|
  s.name          = 'impressionist2'
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

  s.add_dependency 'nokogiri', '~> 1.6'
  s.add_development_dependency 'bundler', '~> 1.0'
end
