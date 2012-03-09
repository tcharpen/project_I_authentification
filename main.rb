require 'sinatra'
require_relative 'lib/user.rb'
require_relative 'lib/checker.rb'

################
##Registration##
################

get '/register' do
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
    @title = 'Registration'
    @target = "\"/registered\"" 
    erb :form
  end
end

##################
##Authentication##
##################

get '/authentication' do
  @title = 'Authentication'
  @target = '"/authenticated"'
  erb :form
end

post '/authenticated' do
  if Checker.check_authentication_params(params)
    response.set_cookie('session_id','un_cookie')
    redirect '/protected'
  else
    @title = 'Authentication'
    @target = "\"/authenticated\"" 
    erb :form
  end
end
