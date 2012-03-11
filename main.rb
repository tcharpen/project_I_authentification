require 'sinatra'
require_relative 'lib/user.rb'
require_relative 'lib/session_manager.rb'
require_relative 'database.rb'

##################
##Protected zone##
##################

set :session_manager, SessionManager.new('server_auth_id')

get '/protected' do
  if settings.session_manager.session(request)
    'You are log in'
  else
    @button = '"Log in"'
    @title = 'Authentication'
    @target = '"/authenticated"'
    erb :form
  end    
end

################
##Registration##
################

get '/register' do
  @button = '"Register"'
  @title = 'Registration'
  @target = '"/registered"'
  erb :form
end


post '/registered' do
  user = User.new( :login => params['login'], :password => params['password'] )
  if user.save
    redirect '/authentication'
  else
    @button = '"Register"'
    @title = 'Registration'
    @target = "\"/registered\"" 
    erb :form
  end
end

##################
##Authentication##
##################

get '/authentication' do
  @button = '"Log in"'
  @title = 'Authentication'
  @target = '"/authenticated"'
  erb :form
end

post '/authenticated' do
  if User.find_user(params['login'],params['password'])
    settings.session_manager.create_session(response)
    redirect '/protected'
  else
    @button = '"Log in"'
    @title = 'Authentication'
    @target = "\"/authenticated\"" 
    erb :form
  end
end
