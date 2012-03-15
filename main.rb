require 'sinatra'
require_relative 'lib/user.rb'
require_relative 'database.rb'

use Rack::Session::Pool

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
  user = User.find_by_login(params[:id]) \
  if session['current_user'] == params[:id]
  
  if user.nil?
    @button = '"Log in"'
    @title = 'Authentication'
    @target = '"/sessions/new"'
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

get '/users/new' do
  @button = '"Register"'
  @title = 'Registration'
  @target = '"/users"'
  erb :form
end

post '/users' do
  user = User.new(:login => params['login'],:password => params['password'])
  if user.save
    redirect '/sessions/new'
  else
    @button = '"Register"'
    @title = 'Registration'
    @target = '"/users/new"' 
    erb :form
  end
end

##################
##Authentication##
##################

get '/sessions/new' do
  @button = '"Log in"'
  @title = 'Authentication'
  @target = '"/sessions"'
  erb :form
end

post '/sessions' do
  user = User.find_user(params['login'],params['password'])
  if user
    session['current_user'] = user.login
    redirect '/protected'
  else
    @button = '"Log in"'
    @title = 'Authentication'
    @target = '"/sessions/new"'
    erb :form
  end
end
