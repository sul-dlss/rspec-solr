#!/usr/bin/env rake
require 'bundler/setup'
require "bundler/gem_tasks"

require 'rake'
require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

Dir.glob('lib/tasks/*.rake').each { |r| import r }

task :default => :ci  
task :spec => :rspec
