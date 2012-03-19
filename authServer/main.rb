require 'sinatra'
require 'sinatra/content_for'
require_relative 'lib/user.rb'
require_relative 'lib/application.rb'
require_relative 'lib/connection.rb'
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
  user = User.find_by_login(session['current_user'])
  app = Application.find_by_name(params['appname'])

  if app
    if user
      Connection.new( :user => user, :application => app ).save
      redirect "#{params['origin']}?secret=#{app.secret}&login=#{user.login}"
    else
      @origin = params['origin']
      @appname = params['appname']
      erb :users_authentication_form
    end
  else
    if user
      erb :users_home_page, :locals => { :user => user }
    else
      erb :users_authentication_form
    end
  end
end

post '/sessions' do
  user = User.find_user(params['login'],params['password'])
  if user
    session['current_user'] = user.login
    if params['app_name'] && params['back_url']
      app = Application.find_by_name(params['app_name'])
      if app
        Connection.new(:user => user, :application => app).save
        redirect "#{params['back_url']}?secret=#{app.secret}&login=#{user.login}"
      else
        redirect "/protected"
      end
    else
      redirect "/protected"
    end

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

  application = Application.new(:name => params['name'], :secret => params['secret'], :user => user)
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
