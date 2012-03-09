require_relative 'spec_helper'

describe 'Server' do
  describe 'Registration' do
    before do
      @params = {'login'=>'toto'}
    end
    context 'in all cases' do
      describe 'get /register' do
        it 'should return a form to users info which' do
          get '/register'
          last_response.body.should match %r{<form.*action="/registered" method="post".*/>}
        end
      end
    end
    context 'in good cases' do
      before do
        Checker.stub(:check_registration_params){true}
      end
      describe 'post /registered' do
        it 'should create a user' do
          User.should_receive(:new).with('toto')
          post '/registered', @params
        end
        it 'should redirect to /authentication' do
          post '/registered', @params
          last_response.status.should be 302
          last_response.header['Location'].should match %r{http://[^/]*/authentication}
        end
        it 'should save the user' do
          user = double('user')
          User.should_receive(:new).with('toto').and_return(user)
          user.should_receive(:save)
          post '/registered', @params
        end
      end
    end
    context 'in bad cases' do
      before do
        Checker.stub(:check_registration_params){false}
      end
      describe 'post /registered' do
        it 'should return a form to post user info' do
          post '/registered'
          last_response.body.should match %r{<form.*action="/registered" method="post".*/>}
        end
      end
    end
  end
  describe 'authentication' do
    before do
      @params = {'login' => 'toto'} 
    end
    context 'in all cases' do
      describe 'get /authentication' do
        it 'should return a form to post user info' do
          get '/authentication'
          last_response.body.should match %r{<form.*action="/authenticated" method="post".*/>}
        end
      end
    end
    context 'in good cases' do
      before do
        Checker.stub(:check_authentication_params){true}
      end
      describe 'post /authenticated' do
        it 'should send a session_id cookie' do
          post '/authenticated', @params
          last_response.header['Set-Cookie'].should_not be_nil
          last_response.header['Set-Cookie'].should match %r{.*session_id=.+}
        end
        it 'should redirect to /protected' do
          post '/authenticated', @params
          last_response.status.should be 302
          last_response.header['Location'].should match %r{http://[^/]*/protected} 
        end
      end
    end
    context 'in bad cases' do
      before do
        Checker.stub(:check_authentication_params){false}
      end
      describe 'post /authenticated' do
        it 'should return a form to post user info' do
          post '/authenticated'
          last_response.body.should match %r{<form.*action="/authentication" method="post".*/>}
        end
      end
    end
  end
end
