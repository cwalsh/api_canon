#!/usr/bin/env rake
begin
  require 'bundler'
  Bundler.require :default, :development
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require "bundler/gem_tasks"
Bundler::GemHelper.install_tasks

begin
  require 'yard'
  YARD::Rake::YardocTask.new do |t|
    t.files   = ['lib/**/*.rb']
    t.options = ['--markup-provider=redcarpet',
                 '--markup=markdown',
                 '--no-private',
                 '--hide-void-return']
  end
end

require "rspec/core/rake_task"

RSpec::Core::RakeTask.new

task :default => :spec
task :test => :spec
