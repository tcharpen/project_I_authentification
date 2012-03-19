require 'spec_helper'

describe 'Users home page' do
  before do
    @user = double('user')
    @user.stub(:admin){false}
    @user.stub(:login){'toto'}
    User.stub(:find_by_login){@user}
  end
  it 'should be a html page' do
    get '/protected'
    last_response.body.should match %r{<!DOCTYPE html>\n?<html>(\n|.)*<body>(\n|.)*</body>(\n|.)*</html>}
  end
  it 'should have the title "Private home page"' do
    get '/protected'
    last_response.body.should match %r{<title>Private home page</title>}
  end
end
