require_relative '../lib/user.rb'
require_relative '../database.rb'

describe User do
  before do
    @login = 'toto'
    @password = '1234'
    User.all.each { |u| u.destroy }
  end
  after do
    User.all.each { |u| u.destroy }
  end
  it 'should have a login' do
    User.new.should respond_to(:login)
  end
  it 'should have a password' do
    User.new.should respond_to(:password)
  end
  it 'User should be able to find a user' do
    User.should respond_to(:find_user)
  end
  describe 'login' do
    it 'should always exists' do
      @login = ''
      User.new(:login =>@login,:password =>@password).valid?.should be_false
    end
    it 'should be unique' do
      User.new(:login =>@login,:password =>@password).save.should be_true
      User.new(:login =>@login,:password =>@password).valid?.should be_false
    end
    it 'should looks like a login' do
      @login = '&#?!'
      User.new(:login =>@login,:password =>@password).valid?.should be_false
    end
  end
  describe 'password' do
    it 'should always exists' do
      @password = ''
      User.new(:login =>@login,:password =>@password).valid?.should be_false
    end
  end
  describe 'self.find_user' do
    context 'if find_user is call with a login and a password which match an existing user' do
      before do 
        @user = User.new(:login =>@login,:password =>@password)
        @user.save
      end
      it 'should return this user' do
        User.find_user(@login,@password).should == @user
      end
    end
    context 'if find_user is call with a login and a password which do not match an existing user' do
      it 'should return nil' do
        User.find_user(@login,@password).should be_nil
      end
    end
  end
end
