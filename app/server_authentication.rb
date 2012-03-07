require 'sinatra'

#There is no database to store users at the moment
#There is no encryption for the user password at the moment

set :user_table, {}

helpers do
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
