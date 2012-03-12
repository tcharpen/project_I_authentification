require 'sinatra'
require_relative 'lib/user.rb'
require_relative 'database.rb'

#############
##Home Page##
#############

get '/' do
  erb :home_page
end

##################
##Protected zone##
##################

get '/protected' do
  user = User.remember(request)
  if user.nil?
    @button = '"Log in"'
    @title = 'Authentication'
    @target = '"/authenticated"'
    erb :form
  elsif user.admin
    erb :admin_page
  else
    'You are log in'
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
  user = User.new(:login => params['login'],:password => params['password'])
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
  user = User.find_user(params['login'],params['password'])
  if user
    user.memorize(response)
    redirect '/protected'
  else
    @button = '"Log in"'
    @title = 'Authentication'
    @target = "\"/authenticated\"" 
    erb :form
  end
end
