require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "impressionist"
  gem.homepage = "http://github.com/cowboycoded/impressionist"
  gem.license = "MIT"
  gem.summary = %Q{Easy way to log impressions}
  gem.description = %Q{Log impressions from controller actions or from a model}
  gem.email = "john.mcaliley@gmail.com"
  gem.authors = ["cowboycoded"]
  gem.files.exclude "test_app"
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

require 'rcov/rcovtask'
Rcov::RcovTask.new do |test|
  test.libs << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "impressionist #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

namespace :version do
  desc "create a new version, create tag and push to github"
  task :patch_release do
    if Jeweler::Commands::ReleaseToGit.new.clean_staging_area?
      Rake::Task['version:bump:patch'].invoke
      Rake::Task['gemspec:release'].invoke
      Rake::Task['git:release'].invoke
    else
      puts "Commit your changed files first"
    end
  end

  desc "create a new version, create tag and push to github"
  task :minor_release do
    if Jeweler::Commands::ReleaseToGit.new.clean_staging_area?
      Rake::Task['version:bump:minor'].invoke
      Rake::Task['gemspec:release'].invoke
      Rake::Task['git:release'].invoke
    else
      puts "Commit your changed files first"
    end      
  end
  
  desc "create a new version, create tag and push to github"
  task :major_release do
    if Jeweler::Commands::ReleaseToGit.new.clean_staging_area?
      Rake::Task['version:bump:major'].invoke
      Rake::Task['gemspec:release'].invoke    
      Rake::Task['git:release'].invoke
    else
      puts "Commit your changed files first"
    end
  end
end

namespace :impressionist do
  require File.dirname(__FILE__) + "/lib/impressionist/bots"
  
  desc "output the list of bots from http://www.user-agents.org/"
  task :bots do  
    p Impressionist::Bots.consume
  end
end