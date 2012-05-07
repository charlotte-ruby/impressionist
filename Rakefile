require 'bundler/setup'
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks

RSpec::Core::RakeTask.new do |task|
  task.rspec_opts = "-I ./test_app/spec"
  task.pattern = "./test_app/spec/**/*_spec.rb"
end

task :test => :spec
task :default => :spec

namespace :impressionist do
  require File.dirname(__FILE__) + "/lib/impressionist/bots"

  desc "output the list of bots from http://www.user-agents.org/"
  task :bots do
    p Impressionist::Bots.consume
  end
end
