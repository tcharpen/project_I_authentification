require 'sinatra'

set :user_table, {}

helpers do
  #We just use a simple global variable to store user accounts
  #A true db will come after
  def find_user(user)
    settings.user_table[user]
  end
  def add_user(user, password)
    settings.user_table[user] = { 'password' => password }
  end
end

get '/register' do
  erb :register
end

post '/registered' do
  
  if params['login'] && params['password']
    if find_user(params['login'])
      redirect '/register'
    else
      add_user(params['login'],params['password'])
      redirect '/session/new'
    end
  else
    redirect '/register'
  end
end
