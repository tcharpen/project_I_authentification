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
  describe 'self.find_user' do
    context 'if parameters match with a user in the database' do
      before do
        User.new(:login => @default_login,:password => @default_password).save
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
  describe 'admin' do
    context 'if the user is an admin' do
      before do
        @user = \
        User.new(
                 :login => @default_login,
                 :password => @default_password,
                 :admin => true
                 )
        @user.save
      end
      it 'should return true' do
        user = User.find_user(@default_login,@default_password)
        user.admin.should be_true
      end
    end
    context 'if the user is not an admin' do
      before do
        @user = \
        User.new(
                 :login => @default_login,
                 :password => @default_password,
                 :admin => false
                 )
        @user.save
      end
      it 'should return false' do
        user = User.find_user(@default_login,@default_password)
        user.admin.should be_false
      end
    end
  end
  describe 'memorize' do
    subject do
      User.new(:login => @default_login,:password => @default_password)
    end
    before do
      @response = double('Rack::Response')
      @response.stub(:set_cookie)
    end
    it 'should store a cookie in the response' do
      @response.should_receive(:set_cookie)
      subject.memorize(@response)
    end
    it 'should store the cookie in the database' do
      subject.should_receive(:cookie=)
      subject.memorize(@response)
    end
  end
  describe 'self.remember' do
    context 'if request comes from a user previously memorized' do
      before do
        @sid = '1664'
        @request = double('Rack::Request')
        @request.stub(:cookies){ {'s_auth_id'=>@sid} }
        @user = \
        User.new(
                 :login => @default_login,
                 :password => @default_password,
                 :cookie => @sid
                 ).save
      end
      it 'should return this user' do
        User.remember(@request).should_not be_nil
        User.remember(@request).login.should == @default_login
      end
    end
    context 'if request comes from a user not memorized' do
      before do
        @sid = '1664'
        @request = double('Rack::Request')
        @request.stub(:cookies){ {'s_auth_id'=>@sid} }
      end
      it 'should return nil' do
        User.remember(@request).should be_nil
      end
    end
  end
end
