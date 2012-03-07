require 'sinatra'
require 'rack/test'
$:.unshift File.join(File.dirname(__FILE__),'..','app')
require 'server_authentication'

describe 'server_authentication' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe 'registration' do

    context 'On request Get /session/register' do

      it 'should return a form' do
        get '/session/register'
        last_request.env[:REQUEST_METHOD].should be 'POST'
      end
      
    end

  end

end
