# encoding: utf-8
require File.expand_path('../lib/impressionist/version', __FILE__)

Gem::Specification.new do |s|
  s.add_dependency 'httpclient', '~> 2.2'
  s.add_dependency 'nokogiri', '~> 1.5'
  s.add_development_dependency 'rdoc', '>= 2.4.2'
  s.authors = ["cowboycoded"]
  s.description = "Log impressions from controller actions or from a model"
  s.email = "john.mcaliley@gmail.com"
  s.files = `git ls-files`.split("\n")
  s.homepage = "https://github.com/charlotte-ruby/impressionist"
  s.licenses = ["MIT"]
  s.name = "impressionist"
  s.require_paths = ["lib"]
  s.required_rubygems_version = Gem::Requirement.new('>= 1.3.6') if s.respond_to? :required_rubygems_version=
  s.summary = "Easy way to log impressions"
  s.test_files = `git ls-files -- test_app/*`.split("\n")
  s.version = Impressionist::VERSION
end
