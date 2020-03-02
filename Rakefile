# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require './lib/resumer/version'

GEM_NAME = 'resumer'
GEM_VERSION = Resumer::VERSION

RSpec::Core::RakeTask.new(:spec)

task default: :spec

task :build do
  system 'gem build ' + GEM_NAME + '.gemspec'
end

task install: :build do
  system 'bundle install'
end

task publish: :build do
  system 'gem push ' + GEM_NAME + '-' + GEM_VERSION + '.gem'
end

task :clean do
  system 'rm *.gem'
end
