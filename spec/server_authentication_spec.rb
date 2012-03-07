require 'rack/test'
$:.unshift File.join(File.dirname(__FILE__),'..','app')
require 'server_authentication'

describe 'server_authentication' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe 'registration' do

    context 'Client send a post without a login or a password at url /registered' do
      it 'should redirect to /session/register' do
        post '/registered'
        last_response.status.should be 302
      end
    end
    
  end

end
