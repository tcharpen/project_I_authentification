require 'sinatra'
require_relative 'lib/user.rb'
require_relative 'lib/application.rb'
require_relative 'database.rb'

use Rack::Session::Pool

enable :method_override # override any post form which contains _method

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
  user = User.find_by_login(session['current_user'])
  if user.nil?
    erb :users_authentication_form
  elsif user.admin
    erb :admin_page, :locals => {:user => user}
  else
    erb :users_home_page, :locals => {:user => user}
  end    
end

################
##Registration##
################

get '/users/new' do
  erb :users_registration_form
end

post '/users' do
  user = User.new(:login => params['login'],:password => params['password'])
  if user.save
    erb :users_authentication_form
  else
    erb :users_registration_form
  end
end

##################
##Authentication##
##################

get '/sessions/new' do
  erb :users_authentication_form
end

post '/sessions' do
  user = User.find_user(params['login'],params['password'])
  if user
    session['current_user'] = user.login
    redirect '/protected'
  else
    erb :users_authentication_form
  end
end

############################
##Application registration##
############################

get '/applications/new' do
  user = User.find_by_login(session['current_user'])
  halt erb :users_authentication_form unless user

  erb :applications_registration_form
end

post '/applications' do
  user = User.find_by_login(session['current_user'])
  halt erb :users_authentication_form unless user

  application = Application.new(:name => params['name'], :url => params['url'], :user => user)
  if application.save
    erb :admin_page, :locals => { :user => user }
  else
    erb :applications_registration_form
  end
end

delete "/applications/:id" do
  user = User.find_by_login(session['current_user'])
  halt erb :users_authentication_form unless user
  
  app = user.applications.find_by_id(params[:id])
  app.delete if app
  erb :admin_page, :locals => { :user => user }
end
