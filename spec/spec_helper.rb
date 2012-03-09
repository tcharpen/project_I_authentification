require 'rack/test'

require_relative '../main'

include Rack::Test::Methods

def app
  Sinatra::Application
end
