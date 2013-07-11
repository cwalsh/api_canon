# Configure Rails Environment
ENV["RAILS_ENV"] = "test"
require 'bundler'
Bundler.setup
class Rails
  def self.version
    '2.3.17'
  end
end
require 'singleton'
require 'action_controller'
require 'api_canon'
# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

