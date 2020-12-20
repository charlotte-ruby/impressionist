require 'bundler/setup'

require 'rspec'
require 'rspec/core/rake_task'
require 'rake/testtask'


RSpec::Core::RakeTask.new(:spec)
task default: :spec

Bundler::GemHelper.install_tasks

namespace :impressionist do
  require "#{File.dirname(__FILE__)}/lib/impressionist/bots"

  desc "output the list of bots from http://www.user-agents.org/"
  task :bots do
    p Impressionist::Bots.consume
  end
end
