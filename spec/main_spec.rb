require_relative 'spec_helper'

describe 'Server' do
  describe 'Registration' do
    before do
      @params = {'login'=>'toto'}
    end
    context 'in all cases' do
      describe 'get /register' do
        it 'should return a form to allow users to post registration info' do
          get '/register'
          last_response.body.should match %r{<form action="/registered" method="post"/>}
        end
      end
    end
    context 'in good cases' do
      before do
        @user = double('user')
        @user.stub(:save){true}
        User.stub(:new){@user}
      end
      describe 'post /registered' do
        it 'should create a user' do
          post '/registered', @params
        end
        it 'should save the user' do
          User.should_receive(:new).with(@params).and_return(@user)
          @user.should_receive(:save)
          post '/registered', @params
        end
        it 'should redirect to /authentication' do
          post '/registered', @params
          last_response.status.should be 302
          last_response.header['Location'].should match %r{http://[^/]*/authentication}
        end
      end
    end
    context 'in bad cases' do
      before do
        @user = double('user')
        @user.stub(:save){false}#Weird behaviour when set to true
        User.stub(:new){@user}
      end
      describe 'post /registered' do
        it 'should return a form to allow users to post registration info' do
          post '/registered'
          last_response.body.should match %r{<form action="/registered" method="post"/>}
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
        it 'should return a form to allow users to post authentication info' do
          get '/authentication'
          last_response.body.should match %r{<form action="/authenticated" method="post"/>}
        end
      end
    end
    context 'in good cases' do
      before do
        User.stub(:where){User.new}
        app.settings.session_manager.stub(:create_session)
      end
      describe 'post /authenticated' do
        it 'should create a session' do
          User.should_receive(:where)
          app.settings.session_manager.should_receive(:create_session)
          post '/authenticated', @params
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
        User.stub(:where){nil}
      end
      describe 'post /authenticated' do
        it 'should return a form to allow users to post authentication info' do
          User.should_receive(:where)
          post '/authenticated'
          last_response.body.should match %r{<form action="/authenticated" method="post"/>}
        end
      end
    end
  end
  describe 'get /protected' do
    context 'if the user is authenticated' do
      before do
        app.settings.session_manager.stub(:session){ {} }
      end
      it 'should return a welcome sentence' do
        get '/protected'
        last_response.status.should == 200
        last_response.body.should == 'You are log in'
      end
    end
    context 'if the user is not authenticated' do
      before do
        app.settings.session_manager.stub(:session){ nil }
      end
      it 'should return a form to allow users to post authentication info' do
        get '/authentication'
        last_response.body.should match %r{<form action="/authenticated" method="post"/>}
      end
    end
  end
end
