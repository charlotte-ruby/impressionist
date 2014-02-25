require 'rake/testtask'

_PATTERN_ = 'tests/generators/**/*_spec.rb'

Bundler::GemHelper.install_tasks

task :default => :test

Rake::TestTask.new do |t|
  t.libs << ['tests/generators', 'lib/generators']
  t.pattern     = _PATTERN_
  t.test_files = FileList[_PATTERN_]
  t.verbose     = false
end
