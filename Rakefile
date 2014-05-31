require 'bundler/gem_tasks'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

require 'rake/extensiontask'
spec = Gem::Specification.load('time_series_math.gemspec')
Rake::ExtensionTask.new('time_series_math_c', spec)

task spec: :compile