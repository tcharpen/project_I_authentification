require 'spec_helper'

describe 'Users home page' do
  before do
    @app1 = double('app1')
    @app1.stub(:name){'MyApp_1'}
    @app2 = double('app2')
    @app2.stub(:name){'MyApp_2'}
    @co1 = double('co1')
    @co1.stub(:application){@app1}
    @co2 = double('co2')
    @co2.stub(:application){@app2}
    @user = double('user')
    @user.stub(:admin){false}
    @user.stub(:login){'toto'}
    @user.stub(:connections){[@co1,@co2]}
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
  it 'should have the list of the applications where the user is connected' do

    get '/protected'
    last_response.body.should match %r{<table>(\n|.)*<tr>(\n|.)*<td>MyApp_1</td>(\n|.)*</tr>(\n|\s)*<tr>(\n|.)*<td>MyApp_2</td>(\n|.)*</tr>(\n|.)*</table>}
  end
end
