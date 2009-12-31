require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

task :default => [:test]

desc 'Test Joule.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib' 
  t.pattern = 'test/**/test_*.rb'
  t.verbose = true
end