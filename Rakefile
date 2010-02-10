require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  require "lib/cruisestatus/version"
  Jeweler::Tasks.new do |gem|
    gem.name        = "cruisestatus"
    gem.summary     = %Q{Check the build status on a cruise.rb server}
    gem.description = %Q{Allows scripts and applications to check the status of your project's build.}
    
    gem.email       = "toby.tripp+git@gmail.com"
    gem.homepage    = "http://github.com/tobytripp/cruisestatus"
    gem.authors     = ["Toby Tripp"]
    
    gem.version     = CruiseStatus::Version::STRING
    
    gem.add_dependency "json_pure", ">= 1.2.0"
    gem.add_dependency "highline",  ">= 1.5.2"
    
    gem.add_development_dependency "rspec", ">= 1.2.9"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

begin
  require "git_precommit"
  GitPrecommit::PrecommitTasks.new

  task :default => ".git/hooks/pre-commit"
  task :precommit => :default
rescue LoadError
  puts "Git pre-commit hooks not loaded."
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "CruiseStatus #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
