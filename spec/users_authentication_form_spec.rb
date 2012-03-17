require_relative 'spec_helper'

describe 'Users authentication page' do
  it 'should be a html page' do
    get '/sessions/new'
    last_response.body.should match %r{<!DOCTYPE html>\n?<html>(\n|.)*<body>(\n|.)*</body>(\n|.)*</html>}
  end
  it 'should have the title "User authentication"' do
    get '/sessions/new'
    last_response.body.should match %r{<title>User authentication</title>}
  end

  it 'should have a form which target post /sessions' do
    get '/sessions/new'
    last_response.body.should match %r{<form action="/sessions" method="post">(\n|.)*<input name="commit" type="submit" value="Submit"/>(\n|.)*</form>}
  end
  describe 'the form which target post /sessions' do
    it 'should have a login input' do
      get '/sessions/new'
      last_response.body.should match %r{<form action="/sessions" method="post">(\n|.)*<input name="login" size="30" type="text"/>(\n|.)*<input name="commit" type="submit" value="Submit"/>(\n|.)*</form>}
    end
    it 'should have a password input' do
      get '/sessions/new'
      last_response.body.should match %r{<form action="/sessions" method="post">(\n|.)*<input name="password" size="30" type="password"/>(\n|.)*<input name="commit" type="submit" value="Submit"/>(\n|.)*</form>}
    end
  end
end
