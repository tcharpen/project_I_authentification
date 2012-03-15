require_relative 'spec_helper'

describe 'Server' do
  before do
    @params = {'login'=>'toto','password'=>'1234'}
  end
  describe 'Home page' do
    describe 'get /' do
      it 'should return a page with a link to /users/new' do
        get '/'
        last_response.body.should match %r{.*<form action="/users/new" method="get">.*}
      end
      it 'should return a page with a link to /sessions/new' do
                get '/'
        last_response.body.should match %r{.*<form action="/sessions/new" method="get">.*}
      end
    end
  end
  describe 'Registration' do
    context 'in all cases' do
      describe 'get /users/new' do
        it 'should return a form to allow users to post registration info' do
          get '/users/new'
          last_response.body.should match %r{<form action="/users" method="post"/>}
        end
      end
    end
    context 'in good cases' do
      before do
        @user = double('user')
        @user.stub(:save){true}
        User.stub(:new){@user}
      end
      describe 'post /users' do
        it 'should create a user' do
          User.should_receive(:new)
          post '/users', @params
        end
        it 'should save the user' do
          User.should_receive(:new).with( :login => @params['login'], :password => @params['password'] ).and_return(@user)
          @user.should_receive(:save)
          post '/users', @params
        end
        it 'should redirect to /sessions/new' do
          post '/users', @params
          last_response.status.should be 302
          last_response.header['Location'].should match %r{http://[^/]*/sessions/new}
        end
      end
    end
    context 'in bad cases' do
      before do
        @user = double('user')
        @user.stub(:save){false}
        User.stub(:new){@user}
      end
      describe 'post /users' do
        it 'should return a form to allow users to post registration info' do
          post '/users'
          last_response.body.should match %r{<form action="/users/new" method="post"/>}
        end
      end
    end
  end
  describe 'authentication' do
    context 'in all cases' do
      describe 'get /sessions/new' do
        it 'should return a form to allow users to post authentication info' do
          get '/sessions/new'
          last_response.body.should match %r{<form action="/sessions" method="post"/>}
        end
      end
    end
    context 'in good cases' do
      before do
        @user = double('user')
        @user.stub(:login){'mock_login'}
        User.stub(:find_user){@user}
      end
      describe 'post /sessions' do
        it 'should return a cookie' do
          User.should_receive(:find_user).with(@params['login'],@params['password']).and_return(@user)
          post '/sessions', @params
          last_response.header['Set-Cookie'].should match %r{rack.session=}
         end
        it 'should redirect to /protected' do
          post '/sessions', @params
          last_response.status.should be 302
          last_response.header['Location'].should match %r{http://[^/]*/protected}
        end
      end
    end
    context 'in bad cases' do
      before do
        User.stub(:find_user){false}
      end
      describe 'post /sessions' do
        it 'should return a form to allow users to post authentication info' do
          User.should_receive(:find_user).with(@params['login'],@params['password'])
          post '/sessions', @params
          last_response.body.should match %r{<form action="/sessions/new" method="post"/>}
        end
      end
    end
  end
  describe 'get /protected' do
    context 'if the user is authenticated' do
      before do
        @user = double('user')
        @user.stub(:nil?){false} #not necessary, i guess
        User.stub(:find_by_login){@user}
      end
      context 'if the user is a non-admin user' do
        before do
          @user.stub(:admin){false}
        end
        it 'should return a welcome sentence' do
          get '/protected'
          last_response.status.should == 200
          last_response.body.should == 'You are log in'
        end
      end
      context 'if the user is an admin user' do
        before do
          @user.stub(:admin){true}
        end
        it 'should return an admin page' do
          get '/protected'
          last_response.status.should == 200
          last_response.body.should match %r{.*Admin page.*}
        end
      end
    end
    context 'if the user is not authenticated' do
      before do
        @user = double('user')
        @user.stub(:nil?){true}
        User.stub(:remember){@user}
      end
      it 'should return a form to allow users to post authentication info' do
        get '/protected'
        last_response.body.should match %r{<form action="/sessions/new" method="post"/>}
      end
    end
  end
end
