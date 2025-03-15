# Ensures that Bundler is responsible for loading and
# managing gem dependencies, providing a reliable and
# consistent environment for running Rake tasks
require "bundler/setup"

# Provides an easy way to define
# a Rake task for running RSpec tests
require "rspec/core/rake_task"

# Creates a Rake task named `spec`, which will run RSpec
# tests when you execute `rake spec` from the command line
RSpec::Core::RakeTask.new(:spec)

# Adding a set of tasks that help with gem development and management
Bundler::GemHelper.install_tasks

# Load the RuboCop Rake task, which is used for running the RuboCop linter
begin
  require "rubocop/rake_task"
  RuboCop::RakeTask.new
rescue LoadError
  desc "Run Rubocop"
  task :rubocop do
    puts "==================================="
    warn " *** Rubocop task is disabled ! ***"
    puts "==================================="
  end
end

# Sets the default tasks.
# When you run `rake` from the command line without specifying
# a task, it will automatically run the :rubocop and :spec task.
task default: [:rubocop, :spec]

# Sets up a Rake tasks within the impressionist namespace
namespace :impressionist do
  require "#{File.dirname(__FILE__)}/lib/impressionist/bots"

  desc "Output the list of bots from http://www.user-agents.org/"
  task :bots do
    Impressionist::Bots.consume.each { |bot| puts bot }
  end
end
