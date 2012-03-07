require 'sinatra'

get '/session/register' do
  'Hello World'
end

post '/registered' do
  if params[:login] && params[:password]
    #TODO
  else
    redirect '/session/register'
  end
end
