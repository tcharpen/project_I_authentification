require 'spec_helper'


describe 'Authentication server' do
  
  describe 'get /' do
    it 'should return the home_page' do
      get '/'
      last_response.status.should be 200
      last_response.body.should match %r{<title>Home page</title>}
    end
  end

  ## resource users
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
    context 'if the model agree registration' do
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
    context 'if the model does not agree registration' do
      it 'should return the users_registration_form' do
        @user = double('user')
        @user.stub(:save){false}
        User.stub(:new){@user}
        post '/users'
        last_response.status.should be 200
        last_response.body.should match %r{<title>User registration</title>}
      end
    end
  end
  describe 'get /users/:id' do
    before do
      @id = '7'
    end
    context 'if the user is authenticated' do
      before do
        @user = double('user')
        @user.stub(:id){@id}
        @user.stub(:login){'toto'}
        User.stub(:find_by_login){@user}
      end
      context 'if the user is not an admin' do
        it 'should return the users_home_page' do
          @user.stub(:admin){false}
          @user.stub(:connections){[]}
          get '/users/7'
          last_response.status.should == 200
          last_response.body.should match %r{<title>Private home page</title>}
        end
      end
      context 'if the user is an admin' do
        it 'should return the admin_page' do
          @user.stub(:connections){[]}
          @user.stub(:applications){[]}
          @user.stub(:admin){true}
          get '/users/7'
          last_response.status.should == 200
          last_response.body.should match %r{<title>Private home page</title>}
        end
      end
    end
    context 'if the user is not authenticated' do
      it 'should return the users_authentication_form' do
        @user = double('user')
        @user.stub(:nil?){true}
        User.stub(:remember){@user}
        get '/users/7'
        last_response.status.should be 200
        last_response.body.should match %r{<title>User authentication</title>}
      end
    end
  end
  
  ## resource sessions
  describe 'get /sessions/new' do
    context 'if the request comes from a user who was redirected by a remote server' do
      before do
        @params = { 'appname' => 'app1', 'origin' => 'http://app1.com/protected' }
      end
      context 'if the remote server is registered in this authentication server' do
        before do
          @app1 = double('app')
          @app1.stub(:secret){'app1secret'}
          Application.stub(:find_by_name){@app1}
        end
        context 'if the user is already authenticated' do
          before do
            @user = double('user')
            @user.stub(:login){'toto'}
            User.stub(:find_by_login){@user}
            @co = double('connection')
            @co.stub(:save)
            Connection.stub(:new){@co}
          end
          it 'should create a Connection object with the user and the application' do
            Connection.should_receive(:new).with( :user => @user, :application => @app1)
            @co.should_receive(:save)
            get '/sessions/new', @params
          end
          it 'should redirect the user to the remote server' do
            get '/sessions/new', @params
            last_response.status.should be 302
            last_response.header['Location'].should match %r{#{@params['origin']}}
          end
          it 'should include the remote server secret in the redirection url' do
            get '/sessions/new', @params
            last_response.status.should be 302
            last_response.header['Location'].should match %r{(\?|&)secret=app1secret}              
          end
          it 'should include the user login in the redirection url' do
            get '/sessions/new', @params
            last_response.status.should be 302
            last_response.header['Location'].should match %r{(\?|&)login=toto}              
          end
        end
        context 'if the user is not authenticated' do 
          before do
            User.stub(:find_by_login){nil}
          end
          it 'should return the users_authentication_form' do
            get '/sessions/new', @params
            last_response.status.should be 200
            last_response.body.should match %r{<title>User authentication</title>}
          end
          it 'should return the url requested by the user in the form as a hidden parameter' do
            get '/sessions/new', @params
            last_response.status.should be 200
            last_response.body.should match %r{<input name="back_url" type="hidden" value="#{@params['origin']}"/>}
          end
          it 'should return the application name requested by the user in the form as a hidden parameter' do
            get '/sessions/new', @params
            last_response.status.should be 200
            last_response.body.should match %r{<input name="app_name" type="hidden" value="#{@params['appname']}"/>}
          end
        end
      end
      context 'if the remote server is not registered in this authentication server' do
        before do
          Application.stub(:find_by_name){nil}
        end
        context 'if the user is already authenticated' do
          it 'should return the users_home_page' do
            
            @user = double('user')
            @user.stub(:login){'toto'}
            @user.stub(:connections){[]}
            @user.stub(:admin){false}
            User.stub(:find_by_login){@user}
            get '/sessions/new', @params
            last_response.status.should be 200
            last_response.body.should match %r{<title>Private home page</title>}
          end
        end
        context 'if the user is not authenticated' do
          it 'should return the users_authentication_form' do
            User.stub(:find_by_login){nil}
            get '/sessions/new', @params
            last_response.status.should be 200
            last_response.body.should match %r{<title>User authentication</title>}                            
          end
        end
      end
    end
    context 'if the request comes from a user who visited this server' do
      before do
        Application.stub(:find_by_name){nil}
      end
      context 'if the user is already authenticated' do
        it 'should return the users_home_page' do
          @user = double('user')
          @user.stub(:login){'toto'}
          @user.stub(:connections){[]}
          @user.stub(:admin){false}
          User.stub(:find_by_login){@user}
          get '/sessions/new', @params
          last_response.status.should be 200
          last_response.body.should match %r{<title>Private home page</title>}              
        end
      end
      context 'if the user is not authenticated' do
        it 'should return the users_authentication_form' do
          User.stub(:find_by_login){nil}
          get '/sessions/new'
          last_response.status.should be 200
          last_response.body.should match %r{<title>User authentication</title>}
        end
      end
    end
  end
  describe 'post /sessions' do
    before do
      @params = {'login'=>'toto','password'=>'1234'}
    end
    context 'if the model agree authentication' do
      before do
        @user = double('user')
        @user.stub(:applications){[]}
        @user.stub(:login){'toto'}
        User.stub(:find_user){@user}
      end
      it 'should return a cookie' do
        User.should_receive(:find_user).with(@params['login'],@params['password']).and_return(@user)
        post '/sessions', @params
        last_response.header['Set-Cookie'].should match %r{rack.session=}
      end
      context 'if the request contains app_name and back_url' do
        before do
          @params = @params.merge({'app_name' => 'app1', 'back_url' => 'http://app1server.com/protected'})
        end
        context 'if app_name match an existing application' do
          before do
            @app = double ('application')
            @app.stub(:secret){'app1secret'}
            Application.stub(:find_by_name){@app}
            @co = double('connection')
            @co.stub(:save)
            Connection.stub(:new){@co}
          end
          it 'should create a Connection object with the user and the application' do
            Connection.should_receive(:new).with( :user => @user, :application => @app)
            @co.should_receive(:save)
            post '/sessions', @params
          end
          it 'should redirect to this url' do
            post '/sessions', @params
            last_response.status.should be 302
            last_response.header['Location'].should match %r{#{@params['back_url']}}
          end
          it 'should include the application secret in the redirection url' do
            post '/sessions', @params
            last_response.status.should be 302
            last_response.header['Location'].should match %r{(\?|&)secret=app1secret}
          end
          it 'should include the user login in the redirecttion url' do
            post '/sessions', @params
            last_response.status.should be 302
            last_response.header['Location'].should match %r{(\?|&)login=#{@params['login']}}
          end
        end
        context 'if the app_name does not match an existing application' do
          it 'should redirect to /protected' do
            Application.stub(:find_by_name){nil}
            post '/sessions', @params
            last_response.status.should be 302
            last_response.header['Location'].should match %r{http://example.org/protected}
          end
        end
      end
      context 'if the request does not contain app_name or back_url' do
        it 'should redirect to /protected' do
          post '/sessions', @params
          last_response.status.should be 302
          last_response.header['Location'].should match %r{http://example.org/protected}
        end
      end
    end
    context 'if the model does not agree authentication' do
      it 'should return the users_authentication_form' do
        User.stub(:find_user){false}
        User.should_receive(:find_user).with(@params['login'],@params['password'])
        post '/sessions', @params
        last_response.status.should be 200
        last_response.body.should match %r{<title>User authentication</title>}
      end
    end
  end

  ## resource applications
  describe 'get /applications/new' do
    context 'if the user is authenticated' do
      it 'should return the applications_registration_form' do
        User.stub(:find_by_login){true}
        get '/applications/new'
        last_response.status.should be 200
        last_response.body.should match %r{<title>Application registration</title>}
      end
    end
    context 'if the user is not authenticated' do
      it 'should return the users_authentication_form' do
        User.stub(:find_by_login){nil}
        get '/applications/new'
        last_response.status.should be 200
        last_response.body.should match %r{<title>User authentication</title>}   
      end
    end
  end
  describe 'post /applications' do
    before do
      @params = { 'name' => 'MyApp', 'secret' => 'MySecret' }
    end
    context 'if the user is authenticated' do
      before do
        @user = double ('user')
        @user.stub(:login){'toto'}
        User.stub(:find_by_login){@user}
      end
      context 'if the model agree the application registration' do
        before do
          @user.stub(:applications){[]}
          @application = double('Application')
          @application.stub(:save){true}
          @user.stub(:connections){[]}
          @user.stub(:admin){false}
          Application.stub(:new){@application}
        end
        it 'should create an application with the name and the secret' do
          Application.should_receive(:new).with(:name => @params['name'], :secret => @params['secret'], :user => @user)
          post '/applications', @params
        end
        it 'should call the model to try to save the application' do
          @application.should_receive(:save)
          post '/applications', @params
        end
        it 'should return the admin_page' do
          post '/applications', @params
          last_response.status.should be 200
          last_response.body.should match %r{<title>Private home page</title>}
        end
      end
      context 'if the model does not agree the application registration' do
        it 'should return the applications_registration_form' do
          @application = double('Application')
          @application.stub(:save){false}
          Application.stub(:new){@application}
          post '/applications', @params
          last_response.status.should be 200
          last_response.body.should match %r{<title>Application registration</title>}
        end
      end
    end
    context 'if the user is not authenticated' do
      it 'should return the users_authentication_form' do
        User.stub(:find_by_login){nil}
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
        @user.stub(:admin){true}
        @user.stub(:login){'toto'}
        @user.stub(:connections){[]}
        @user.stub(:applications).and_return(@app_group,[])
        User.stub(:find_by_login){@user}
      end
      it 'should delete the application matching the id and the user' do
        User.should_receive(:find_by_login)
        @user.should_receive(:applications).twice
        @app_group.should_receive(:find_by_id).with(@id)
        @app.should_receive(:delete)
        delete "/applications/#{@id}"
      end
      it 'should return the admin_page' do
        delete "/applications/#{@id}"
        last_response.status.should be 200
        last_response.body.should match %r{<title>Private home page</title>}
      end
    end
    context 'if the current session does not match an existing user' do
      it 'should return the users_authentication_form' do
        User.stub(:find_by_login){nil}
        delete "/applications/#{@id}"
        last_response.status.should be 200
        last_response.body.should match %r{<title>User authentication</title>}
      end
    end
  end
end

