require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

if RUBY_VERSION.to_f < 1.9
    begin
        require 'jeweler'
        Jeweler::Tasks.new do |s|
            s.name        = 'zzot-semi-static'
            s.summary     = 'Semi-Static is yet another static site generator.'
            s.email       = 'projects@zzot.net'
            s.homepage    = 'http://github.com/zzot/semi-static'
            s.description = 'Semi-Static is yet another static site generator.'
            s.authors     = ['Josh Dady']
            s.add_dependency('maruku', '>= 0.5.9')
            s.add_dependency('haml', '>= 2.0.6')
        end
    rescue LoadError
        puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
    end
end

Rake::TestTask.new do |t|
    t.libs << 'lib'
    t.pattern = 'test/**/test_*.rb'
    t.verbose = false
end
task :default => :test

Rake::RDocTask.new do |r|
    r.title    = 'semi-static'
    r.options << '--line-numbers' << '--inline-source'
    r.rdoc_files.include 'README*', 'lib/**/*.rb'
end
