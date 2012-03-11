require_relative '../lib/user.rb'
require_relative '../database.rb'

describe User do
  before do
    User.all.each { |u| u.destroy }
  end
  after do
    User.all.each { |u| u.destroy }
  end
  describe 'save' do
    context 'if the user has a login length greater than 4' do
      it 'should return true' do
        User.new( :login => '123' ).save.should be_false
        User.new( :login => '1234' ).save.should be_true
      end
    end
    context 'it the user login is already used' do
      it 'should return false' do
        login = 'toto'
        user = User.new( :login => login ).save.should be_true
        User.new( :login => login ).save.should be_false
      end
    end
  end
  describe 'find_user' do
    context 'if the user we look for is in the database' do
      it 'should return this user' do
        login = 'toto'
        User.new( :login => login ).save.should be_true
        User.find_user(login).login.should == login
      end
    end
    context 'if the user we look for is not in the database' do
      it 'should return false' do
        User.find_user('toto').should be_false
      end
    end
  end
end
