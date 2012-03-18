require 'spec_helper'

describe 'app1' do
  describe 'get /' do
    it 'should return the home_page' do
        get '/'
        last_response.body.should match %r{<title>Home page</title>}      
    end
  end
  describe 'get /protected' do
    context 'if the user is authenticated' do
      it 'should return the application_page' do
        session = {'rack.session'=> {'current_user' => 'toto'} }
        get '/protected', {}, session
        last_response.body.should match %r{<title>Application</title>}
      end
    end
    context 'if the user is not authenticated' do
      before do
        @session = { 'rack.session' => nil }
      end
      it 'should redirect to the authentication server' do
        get '/protected', {}, @session
        last_response.status.should be 302
        last_response.header['Location'].should match %r{http://server_authentication}
      end
      describe 'redirection to the authentication server' do
        it 'should target /sessions/new' do
        get '/protected', {}, @session
        last_response.status.should be 302
        last_response.header['Location'].should match %r{http://server_authentication/sessions/new}          
        end
        it 'should forward the application name' do
          get '/protected', {}, @session
          last_response.status.should be 302
          last_response.header['Location'].should match %r{(\?|&)\w*appname=app1}
        end
        it 'should forward the page requested' do
          get '/protected', {}, @session
          last_response.status.should be 302
          last_response.header['Location'].should match %r{(\?|&)\w*origin=/protected}
        end
      end
    end
    context 'if the request contains a login and a secret matching the application secret' do
      it 'should create a session by sending a cookie' do
        get '/protected?login=toto&secret=app1secret'
        last_response.header['Set-Cookie'].should match %r{rack.session=.+}
      end
    end
  end
end
