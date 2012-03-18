require 'sinatra'

use Rack::Session::Pool

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
  session['current_user'] = params[:login]  if params[:secret] == 'app1secret'

  if session['current_user']
    erb :application_page
  else
    redirect "http://server_authentication/sessions/new?appname=app1&origin=#{request.path}"
  end
end
