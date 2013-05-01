# Configure Rails Environment
ENV["RAILS_ENV"] = "test"
require 'rails'
require 'singleton'
require 'action_controller'
require 'api_canon'
# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

