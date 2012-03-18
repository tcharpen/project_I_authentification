require 'spec_helper'

describe 'Server' do
  describe 'Home page' do
    describe 'get /' do
      it 'should return the home_page' do
        get '/'
        last_response.status.should be 200
        last_response.body.should match %r{<title>Home page</title>}
      end
    end
  end
  describe 'Registration' do
    describe 'get /users/new' do
      it 'should return the users_registration_form' do
        get '/users/new'
        last_response.status.should be 200
        last_response.body.should match %r{<title>User registration</title>}
      end
    end
    describe 'post /users' do
      before do
        @params = {'login'=>'toto','password'=>'1234'}
      end
      context 'if the model agree parameters' do
        before do
          @user = double('user')
          @user.stub(:save){true}
          User.stub(:new){@user}
        end
        it 'should create a user' do
          User.should_receive(:new)
          post '/users', @params
        end
        it 'should call the model to try to save the user' do
          User.should_receive(:new).with( :login => @params['login'], :password => @params['password'] ).and_return(@user)
          @user.should_receive(:save)
          post '/users', @params
        end
        it 'should return the users_authentication_form' do
          post '/users', @params
          last_response.status.should be 200
          last_response.body.should match %r{<title>User authentication</title>}
        end
      end
      context 'if the model does not agree parameters' do
        before do
          @user = double('user')
          @user.stub(:save){false}
          User.stub(:new){@user}
        end
        it 'should return the users_registration_form' do
          post '/users'
          last_response.status.should be 200
          last_response.body.should match %r{<title>User registration</title>}
        end
      end
    end
  end
  describe 'Authentication' do
    describe 'get /sessions/new' do
      it 'should return the users_authentication_form' do
        get '/sessions/new'
        last_response.status.should be 200
        last_response.body.should match %r{<title>User authentication</title>}
      end
    end
    describe 'post /sessions' do
      before do
        @params = {'login'=>'toto','password'=>'1234'}
      end
      context 'if the model agree parameters' do
        before do
          @user = double('user')
          @user.stub(:applications){[]}
          @user.stub(:login){'mock_login'}
          User.stub(:find_user){@user}
        end
        it 'should return a cookie' do
          User.should_receive(:find_user).with(@params['login'],@params['password']).and_return(@user)
          post '/sessions', @params
          last_response.header['Set-Cookie'].should match %r{rack.session=}
        end
        it 'should redirect to /protected' do
          post '/sessions', @params
          last_response.status.should be 302
          last_response.header['Location'].should match %r{/protected}
        end
      end
      context 'if the model does not agree parameters' do
        before do
          User.stub(:find_user){false}
        end
        it 'should return the users_authentication_form' do
          User.should_receive(:find_user).with(@params['login'],@params['password'])
          post '/sessions', @params
          last_response.status.should be 200
          last_response.body.should match %r{<title>User authentication</title>}
        end
      end
    end
  end
  describe 'Protected zone' do
    describe 'get /protected' do
      context 'if the user is authenticated' do
        before do
          @user = double('user')
          @user.stub(:nil?){false} #not necessary, i guess
          @user.stub(:login){'toto'}
          User.stub(:find_by_login){@user}
        end
        context 'if the user is not an admin' do
          before do
            @user.stub(:admin){false}
          end
          it 'should return the users_home_page' do
            get '/protected'
            last_response.status.should == 200
            last_response.body.should match %r{<title>Private home page</title>}
          end
        end
        context 'if the user is an admin' do
          before do
            @user.stub(:applications){[]}
            @user.stub(:admin){true}
          end
          it 'should return the admin_page' do
            get '/protected'
            last_response.status.should == 200
            last_response.body.should match %r{<title>Applications administrator page</title>}
          end
        end
      end
      context 'if the user is not authenticated' do
        before do
          @user = double('user')
          @user.stub(:nil?){true}
          User.stub(:remember){@user}
        end
        it 'should return the users_authentication_form' do
          get '/protected'
          last_response.status.should be 200
          last_response.body.should match %r{<title>User authentication</title>}
        end
      end
    end
  end
  describe 'Applications registration' do
    describe 'get /applications/new' do
      context 'if the user is authenticated' do
        before do
          User.stub(:find_by_login){true}
        end
        it 'should return the applications_registration_form' do
          get '/applications/new'
          last_response.status.should be 200
          last_response.body.should match %r{<title>Application registration</title>}
        end
      end
      context 'if the user is not authenticated' do
        before do
          User.stub(:find_by_login){nil}
        end
        it 'should return the users_authentication_form' do
          get '/applications/new'
          last_response.status.should be 200
          last_response.body.should match %r{<title>User authentication</title>}   
        end
      end
    end
    describe 'post /applications' do
      before do
        @params = { 'name' => 'MyApp', 'url' => 'http://MyUrl.com' }
      end
      context 'if the user is authenticated' do
        before do
          @user = double ('user')
          @user.stub(:login){'toto'}
          User.stub(:find_by_login){@user}
        end
        context 'if the model agree parameters' do
          before do
            @user.stub(:applications){[]}
            @application = double('Application')
            @application.stub(:save){true}
            Application.stub(:new){@application}
          end
          it 'should create an application with the name and the url in the post request' do
            Application.should_receive(:new).with(:name => @params['name'], :url => @params['url'], :user => @user)
            post '/applications', @params
          end
          it 'should call the model to try to save the application' do
            @application.should_receive(:save)
            post '/applications', @params
          end
          it 'should return the admin_page' do
            post '/applications', @params
            last_response.status.should be 200
            last_response.body.should match %r{<title>Applications administrator page</title>}
          end
        end
        context 'if the model does not agree parameters' do
          before do
            @application = double('Application')
            @application.stub(:save){false}
            Application.stub(:new){@application}
          end
          it 'should return the applications_registration_form' do
            post '/applications', @params
            last_response.status.should be 200
            last_response.body.should match %r{<title>Application registration</title>}
          end
        end
      end
      context 'if the user is not authenticated' do
        before do
          User.stub(:find_by_login){nil}
        end
        it 'should return the users_authentication_form' do
          post '/applications', @params
          last_response.status.should be 200
          last_response.body.should match %r{<title>User authentication</title>}
        end
      end
    end
    describe 'delete /applications/:id' do
      before do
        @id = '7'
      end
      context 'if the current session match an existing user' do
        before do
          @app = double('application')
          @app.stub(:delete)
          @app_group = double('applications')
          @app_group.stub(:find_by_id){@app}
          @user = double('user')
          @user.stub(:applications){@app_group}
          User.stub(:find_by_login){@user}
        end
        it 'should delete the application matching the id and the user' do
          @user.stub(:applications).and_return(@app_group,[])
          @user.stub(:login){'toto'}
          User.should_receive(:find_by_login)
          @user.should_receive(:applications).twice
          @app_group.should_receive(:find_by_id).with(@id)
          @app.should_receive(:delete)
          delete "/applications/#{@id}"
        end
        it 'should return the admin_page' do
          @user.stub(:applications).and_return(@app_group,[])
          @user.stub(:login){'toto'}
          delete "/applications/#{@id}"
          last_response.status.should be 200
          last_response.body.should match %r{<title>Applications administrator page</title>}
        end
      end
      context 'if the current session does not match an existing user' do
        it 'should return the users_authentication_form' do
          delete "/applications/#{@id}"
          last_response.status.should be 200
          last_response.body.should match %r{<title>User authentication</title>}
        end
      end
    end
  end
end

