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

require 'json_spec'
RSpec.configure do |config|
  config.include JsonSpec::Helpers
end

Combustion.initialize!
