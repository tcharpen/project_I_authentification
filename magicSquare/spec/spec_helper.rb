require 'rack/test'

require_relative '../magicSquare'

include Rack::Test::Methods

def app
  Sinatra::Application
end
