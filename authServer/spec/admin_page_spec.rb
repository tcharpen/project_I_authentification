require 'spec_helper'

describe 'Applications administrator page' do
  before do
    @app_1 = double('application')
    @app_2 = double('application')
    @app_1.stub(:name){'MyApp_1'}
    @app_1.stub(:secret){'MyApp_1_secret'}
    @app_1.stub(:id){1}
    @app_2.stub(:name){'MyApp_2'}
    @app_2.stub(:secret){'MyApp_2_secret'}    
    @app_2.stub(:id){2}
    @app_array = [@app_1,@app_2]
    @user = double('user')
    @user.stub(:connections){[]}
    @user.stub(:applications){@app_array}
    @user.stub(:admin){true}
    @user.stub(:login){'toto'}
    User.stub(:find_by_login){@user}
  end
  it 'should be a html page' do
    get '/protected'
    last_response.body.should match %r{<!DOCTYPE html>\n?<html>(\n|.)*<body>(\n|.)*</body>(\n|.)*</html>}
  end
  it 'should have the title "Applications administrator page"' do
    get '/protected'
    last_response.body.should match %r{<title>Applications administrator page</title>}
  end

  it 'should have a link to get /applications/new' do
    get '/protected'
    last_response.body.should match %r{<form action="/applications/new" method="get">(\n|.)*<input type="submit" value="Add application">(\n|.)*</form>}
  end
  it 'should have the applications list' do
    get '/protected'
    last_response.body.should match %r{<table>(\n|.)*<tr>(\n|.)*<td>MyApp_1</td>(\n|.)*<td>MyApp_1_secret</td>(\n|.)*</tr>(\n|\s)*<tr>(\n|.)*<td>MyApp_2</td>(\n|.)*<td>MyApp_2_secret</td>(\n|.)*</tr>(\n|.)*</table>}
  end
  it 'should have a link to delete /applications/:id' do
    get '/protected'
    last_response.body.should match %r{<form action="/applications/2" method="post">(\n|.)*<input type="hidden" name="_method" value="delete">(\n|.)*<input type="submit" value="Delete">(\n|.)* </form>}
    last_response.body.should match %r{<form action="/applications/1" method="post">(\n|.)*<input type="hidden" name="_method" value="delete">(\n|.)*<input type="submit" value="Delete">(\n|.)* </form>}
  end
end
