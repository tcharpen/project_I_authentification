require 'rack/test'

require_relative '../hitTheDot'

include Rack::Test::Methods

def app
  Sinatra::Application
end
