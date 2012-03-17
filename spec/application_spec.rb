require_relative '../lib/application.rb'
require_relative '../lib/user.rb'
require_relative '../database.rb'

describe Application do
  before do
    Application.all.each { |a| a.destroy }
  end
  after do 
    Application.all.each { |a| a.destroy }
  end
  it 'should have a name' do
    should respond_to(:name)
  end
  it 'should have an url' do
    should respond_to(:url)
  end
  it 'should have a user' do
    should respond_to(:user)
  end
  describe 'name' do
    before do
      @user = User.new(:login => 'toto', :password => '1234')
    end
    it 'should always exists' do      
      Application.new(:name => '', :url => 'http://MyUrl.com', :user => @user).valid?.should be_false
    end
    it 'should looks like an application name' do
      user = User.new(:login => 'toto', :password => '1234')    
      Application.new(:name => '?!&^#', :url => 'http://MyUrl.com', :user => @user).valid?.should be_false      
    end
    it 'should be unique' do
      user = User.new(:login => 'toto', :password => '1234')
      Application.new(:name => 'toto', :url => 'http://MyUrl.com', :user => @user).save.should be_true
      Application.new(:name => 'toto', :url => 'http://MyUrl.com', :user => @user).save.should be_false
    end
  end
  describe 'url' do
    it 'should always exists' do 
      Application.new(:name => 'toto', :url => '').valid?.should be_false
    end
    it 'should looks like an url' do
      Application.new(:name => 'toto', :url => 'I am not an URL').valid?.should be_false
    end
  end
  describe 'user' do
    it 'should always exists' do
      Application.new(:name => 'toto', :url => 'http://MyUrl.com').save.should be_false
    end
  end
end

