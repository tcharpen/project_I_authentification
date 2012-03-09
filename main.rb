require 'sinatra'
require_relative 'lib/user.rb'
require_relative 'lib/checker.rb'

################
##Registration##
################

get '/register' do
  @target = "\"/registered\"" 
  erb :form
end

post '/registered' do
  if Checker.check_registration_params(params)
    user = User.new(params['login'])
    user.save
    redirect '/authentication'
  else
    @target = "\"/registered\"" 
    erb :form
  end
end

##################
##Authentication##
##################

get '/authentication' do
    @target = "\"/authenticated\"" 
    erb :form
end

post '/authenticated' do
  if Checker.check_authentication_params(params)
    response.set_cookie('session_id','un_cookie')
    redirect '/protected'
  else
    @target = "\"/authentication\"" 
    erb :form
  end
end
