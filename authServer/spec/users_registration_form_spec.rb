require 'spec_helper'

describe 'Users registration page' do
  it 'should be a html page' do
    get '/users/new'
    last_response.body.should match %r{<!DOCTYPE html>\n?<html>(\n|.)*<body>(\n|.)*</body>(\n|.)*</html>}
  end
  it 'should have the title "User registration"' do
    get '/users/new'
    last_response.body.should match %r{<title>User registration</title>}
  end

  it 'should have a form which target post /users' do
    get '/users/new'
    last_response.body.should match %r{<form action="/users" method="post">(\n|.)*<input name="commit" type="submit" value="Submit"/>(\n|.)*</form>}
  end
  describe 'the form which target post /users' do
    it 'should have a login input' do
      get '/users/new'
      last_response.body.should match %r{<form action="/users" method="post">(\n|.)*<input name="login" size="30" type="text"/>(\n|.)*<input name="commit" type="submit" value="Submit"/>(\n|.)*</form>}
    end
    it 'should have a password input' do
      get '/users/new'
      last_response.body.should match %r{<form action="/users" method="post">(\n|.)*<input name="password" size="30" type="password"/>(\n|.)*<input name="commit" type="submit" value="Submit"/>(\n|.)*</form>}
    end
  end
end
