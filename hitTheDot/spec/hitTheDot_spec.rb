require 'spec_helper'

describe 'Hit The Dot' do
  describe 'get /' do
    it 'should return the home_page' do
        get '/'
        last_response.body.should match %r{<title>Home page</title>}      
    end
  end
  describe 'get /protected' do
    context 'if the user is authenticated' do
      it 'should return the application_page' do
        get '/protected', {}, {'rack.session'=> {'current_user' => 'toto'} }
        last_response.body.should match %r{<title>Application</title>}
      end
    end
    context 'if the user is not authenticated' do
      before do
        @session = { 'rack.session' => nil }
        @url = "#{app.settings.s_auth_url}:#{app.settings.s_auth_port}"
      end
      it 'should redirect to the authentication server' do
        get '/protected', {}, @session
        last_response.status.should be 302
        last_response.header['Location'].should match %r{#{@url}}
      end
      describe 'redirection to the authentication server' do
        it 'should target /sessions/new' do
        get '/protected', {}, @session
        last_response.status.should be 302
          last_response.header['Location'].should match %r{#{@url}/sessions/new}          
        end
        it 'should forward the application name' do
          get '/protected', {}, @session
          last_response.status.should be 302
          last_response.header['Location'].should match %r{(\?|&)\w*appname=#{app.settings.appname}}
        end
        it 'should forward the page requested' do
          get '/protected', {}, @session
          last_response.status.should be 302
          last_response.header['Location'].should match %r{(\?|&)\w*origin=http://example.org:#{app.settings.port}/protected}
        end
      end
    end
    context 'if the request contains a login and a secret matching the application secret' do
      it 'should create a session by sending a cookie' do
        get "/protected?login=toto&secret=#{app.settings.secret}"
        last_response.header['Set-Cookie'].should_not be_nil
        last_response.header['Set-Cookie'].should match %r{hitthedot.session=.+}

      end
    end
  end
end
