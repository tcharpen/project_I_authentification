require 'rack/test'

require_relative '../app1'

include Rack::Test::Methods

def app
  Sinatra::Application
end
