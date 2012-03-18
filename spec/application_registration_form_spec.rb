require 'spec_helper'

describe 'Applications registration page' do
  before do
    User.stub(:find_by_login){true}
  end
  it 'should be a html page' do
    get '/applications/new'
    last_response.body.should match %r{<!DOCTYPE html>\n?<html>(\n|.)*<body>(\n|.)*</body>(\n|.)*</html>}
  end
  it 'should have the title "Application registration"' do
    get '/applications/new'
    last_response.body.should match %r{<title>Application registration</title>}
  end
  it 'should have a form which target post /applications' do
    get '/applications/new'
    last_response.body.should match %r{<form action="/applications" method="post">(\n|.)*<input name="commit" type="submit" value="Submit"/>(\n|.)*</form>}
  end
  describe 'the form which target post /applications' do
    it 'should have a name input' do
      get '/applications/new'
      last_response.body.should match %r{<form action="/applications" method="post">(\n|.)*<input name="name" size="30" type="text"/>(\n|.)*<input name="commit" type="submit" value="Submit"/>(\n|.)*</form>}
    end
    it 'should have a secret input' do
      get '/applications/new'
      last_response.body.should match %r{<form action="/applications" method="post">(\n|.)*<input name="secret" size="30" type="text"/>(\n|.)*<input name="commit" type="submit" value="Submit"/>(\n|.)*</form>}
    end
  end
end
