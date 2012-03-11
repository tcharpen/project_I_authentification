require_relative '../lib/user.rb'
require_relative '../database.rb'

describe User do
  before do
    @default_login = 'toto'
    @default_password = '1234'
    User.all.each { |u| u.destroy }
  end
  after do
    User.all.each { |u| u.destroy }
  end
  describe 'save' do
    context 'if the user has a login length greater than 4 or equal' do
      before do
        @login_ge_4 = '12345'
      end
      it 'should return true' do
        User.new(:login => @login_ge_4,:password => @default_password).save.should be_true
      end
    end
    context 'if the user has a login length lower than 4' do
      before do
        @login_lt_4 = '123'
      end
      it 'should return false' do
        User.new( :login => @login_lt_4, :password => @default_password ).save.should be_false
      end
    end
    context 'if the user login is already used' do
      before do
        User.new(:login => @default_login,:password => @default_password).save
      end
      it 'should return false' do
        User.new(:login => @default_login,:password => @default_password).save.should be_false
      end
    end
    context 'if the user login is unsused' do
      it 'should return true' do
        User.new(:login => @default_login,:password => @default_password).save.should be_true
      end
    end
    context 'if the user password length is greater than 4 or equal' do
      before do
        @pwd_ge_4 = '12345'
      end
      it 'should return true' do
        User.new(:login => @default_login,:password => @pwd_ge_4).save.should be_true
      end
    end
    context 'if the user password length is lower than 4' do
      before do
        @pwd_lt_4 = '123'
      end
      it 'should return false' do
        User.new(:login => @default_login,:password => @pwd_lt_4).save.should be_false
      end
    end
  end
  describe 'find_user' do
    context 'if parameters match with a user in the database' do
      before do
        User.new(:login => @default_login,:password => @default_password).save.should be_true
      end
      it 'should return this user' do
        User.find_user(@default_login,@default_password).login.should == @default_login
      end
    end
    context 'if parameters do not match a user in the database' do
      it 'should return false' do
        User.find_user(@default_login,@default_password).should be_false
      end
    end
  end
end
