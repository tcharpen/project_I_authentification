require 'sinatra'

use Rack::Session::Pool

set :s_auth_url, 'http://serverauth'
set :s_auth_port, 4567
set :port, 4568
set :secret, 'hitthedotsecret'
set :appname, 'hitthedot'

##########
##public##
##########

get '/' do
  erb :home_page
end

#############
##protected##
#############

get '/protected' do
  session['current_user'] = params[:login]  if params[:secret] == settings.secret

  if session['current_user']
    erb :hitthedot_page
  else
    redirect "#{settings.s_auth_url}:#{settings.s_auth_port}/sessions/new?appname=#{settings.appname}&origin=http://#{request.host}:#{settings.port}#{request.path}"
  end
end
