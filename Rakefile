require 'bundler/setup'
require 'rspec/core/rake_task'
require 'rake/testtask'

Bundler::GemHelper.install_tasks

# Impressionist will use MiniTest instead of RSpec
RSpec::Core::RakeTask.new do |task|
  task.rspec_opts = "-I ./tests/test_app/spec"
  task.pattern = "./tests/test_app/spec/**/*_spec.rb"
end

task :test_app => :spec
task :default => [:test, :test_app]

namespace :impressionist do
  require File.dirname(__FILE__) + "/lib/impressionist/bots"

  desc "output the list of bots from http://www.user-agents.org/"
  task :bots do
    p Impressionist::Bots.consume
  end

end

# setup :test task to minitest
# Rake libs default is lib
# libs << path to load test_helper, etc..
Rake::TestTask.new do |t|
  t.libs << "tests/spec"
  t.pattern     = "tests/spec/**/*_spec.rb"
  t.test_files =  FileList["tests/spec/**/*_spec.rb"]
  t.verbose     = true
end
