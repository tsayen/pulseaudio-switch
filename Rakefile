require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'bundler/gem_tasks'

RSpec::Core::RakeTask.new :spec

RuboCop::RakeTask.new :rubocop

task default: [:rubocop, :spec, :build]
