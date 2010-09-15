require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'rake/gempackagetask'

task :default => [:test]

desc 'Test Joule.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib' 
  t.libs << 'test/lib' 
  t.pattern = 'test/**/*test.rb'
  t.verbose = true
end

spec = Gem::Specification.new do |s|
  s.name = "joule"
  s.summary = "A Ruby library for parsing bicycle powermeter data."
  s.description = "Joule parses and does some basic analyzing of powermeter data. Supported formats include SRM(.srm), Saris PowerTap(.csv), iBike(.csv), and Garmin(.tcx)"
  s.homepage = "http://github.com/anolson/joule"
  
  s.version = "1.0.0"
  s.date = "2010-1-5"
  
  s.authors = ["Andrew Olson"]
  s.email = "anolson@gmail.com"
  
  s.require_paths = ["lib"]
  s.files = Dir["lib/**/*"] + ["README.rdoc", "Rakefile"]
  s.extra_rdoc_files = ["README.rdoc"]
  
  s.has_rdoc = true
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Joule", "--main", "README.rdoc"]
  
  s.rubygems_version = "1.3.4"
  s.required_rubygems_version = Gem::Requirement.new(">= 1.2")
  s.add_dependency("nokogiri", ">= 1.4.1")
  s.add_dependency("fastercsv", ">=1.4.0")
end


Rake::GemPackageTask.new(spec) do |pkg| 
  pkg.need_tar = true 
end 

Rake::RDocTask.new do |doc|
  doc.main = "README.rdoc"
  doc.rdoc_files.include("README.rdoc", "lib/**/*.rb")
  doc.rdoc_dir = "doc"
end


