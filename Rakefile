#!/usr/bin/env rake

require 'bundler'
Bundler::GemHelper.install_tasks

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "impressionist #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

namespace :impressionist do
  require File.dirname(__FILE__) + "/lib/impressionist/bots"

  desc "output the list of bots from http://www.user-agents.org/"
  task :bots do
    p Impressionist::Bots.consume
  end
end
