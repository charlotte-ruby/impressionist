require 'rake/testtask'

_PATTERN_ = 'tests/spec/**/*_spec.rb'

Bundler::GemHelper.install_tasks

task :default => :test

##
# libs << path.. to load minitest_helper.rb
Rake::TestTask.new do |t|
  t.libs << ['tests/spec', 'lib/generators']
  t.pattern     = _PATTERN_
  t.test_files = FileList[_PATTERN_]
  t.verbose     = false
end
