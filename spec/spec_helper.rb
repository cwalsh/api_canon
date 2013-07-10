# Configure Rails Environment
ENV["RAILS_ENV"] = "test"
require 'rails'
require 'singleton'
require 'action_controller'
require 'pry'
require 'combustion'
require 'rspec'
require 'rspec/rails'
require 'api_canon'
Combustion.initialize!