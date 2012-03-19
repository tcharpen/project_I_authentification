require 'spec_helper'

describe 'Home Page' do
  it 'should be a html page' do
    get '/'
    last_response.body.should match %r{<!DOCTYPE html>\n?<html>(\n|.)*<body>(\n|.)*</body>(\n|.)*</html>}
  end
  it 'should have the title "Home page"' do
    get '/'
    last_response.body.should match %r{<title>Home page</title>}
  end
  it 'should have a link to get /users/new' do
    get '/'
    last_response.body.should match %r{<form action="/users/new" method="get">(\n|.)*<input type="submit" value="Register">(\n|.)*</form>}
  end
  it 'should have a link to get /sessions/new' do
    get '/'
    last_response.body.should match %r{<form action="/sessions/new" method="get">(\n|.)*<input type="submit" value="Log In">(\n|.)*</form>}
  end
end
