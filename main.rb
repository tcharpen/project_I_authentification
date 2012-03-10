require 'sinatra'
require_relative 'lib/user.rb'
require_relative 'lib/checker.rb'
require_relative 'lib/session_manager.rb'

##################
##Protected zone##
##################

set :session_manager, SessionManager.new('server_auth_id')

get '/protected' do
  if settings.session_manager.session(env)
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
  if Checker.check_registration_params(params)
    user = User.new(params['login'])
    user.save
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
  if Checker.check_authentication_params(params)
    settings.session_manager.create_session
    redirect '/protected'
  else
    @button = '"Log in"'
    @title = 'Authentication'
    @target = "\"/authenticated\"" 
    erb :form
  end
end
