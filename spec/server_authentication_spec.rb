require 'rack/test'
$:.unshift File.join(File.dirname(__FILE__),'..','app')
require 'server_authentication'

describe 'server_authentication' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe 'registration' do

    context 'Client send an invalid post /registered' do
      context 'with a password, without a login' do
        it 'should redirect to /register' do
          post '/registered', {'password' => '1234'}
          last_response.status.should be 302
          last_response.header['Location'].should match(/^http:\/\/[^\/]*\/register$/)
        end
      end
      context 'without a password, with a login' do
        it 'should redirect to /register' do
          post '/registered', {'login' => 'toto'}
          last_response.status.should be 302
          last_response.header['Location'].should match(/^http:\/\/[^\/]*\/register$/)
        end
      end
      context 'without a password, without a login' do
        it 'should redirect to /register' do
          post '/registered', {}
          last_response.status.should be 302
          last_response.header['Location'].should match(/^http:\/\/[^\/]*\/register$/)
        end
      end
      context 'with a password, with a login already use' do
        it 'should redirect to /register' do
          post '/registered', {'login' => 'toto', 'password' => '1234'}
          post '/registered', {'login' => 'toto', 'password' => '4321'}
          last_response.status.should be 302
          last_response.header['Location'].should match(/^http:\/\/[^\/]*\/register$/)
        end
      end
      context 'Client send a valid post /registered' do
        context 'with a password, with a free login' do
          it 'should redirect to /session/new' do
            post '/registered', {'login' => 'titi', 'password' => '4321'}
            last_response.status.should be 302
            last_response.header['Location'].should match(/^http:\/\/[^\/]*\/session\/new$/)
          end
          it 'should store the user login and password' do
            #TODO, I don't know how to do that
          end
        end
      end

    end
    
  end
  
end
