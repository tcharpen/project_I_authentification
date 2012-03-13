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
  describe 'save' do
    context 'if the user login length is between 4 and 15 (bound included)' do
      it 'should return true' do
        User.new(:login => @login,:password => @password).save.should be_true
      end
      it 'should store the user in memory' do
        User.new(:login => @login,:password => @password).save.should be_true
        User.find_by_login(@login).should be_true
      end
    end
    context 'if the user login length is greater than 15' do
      before do
        @login = 'login_greater_than_15'
      end
      it 'should return false' do
        User.new(:login => @login,:password => @password).save.should be_false
      end
      it 'should not store the user in memory' do
        User.new(:login => @login,:password => @password).save.should be_false
        User.find_by_login(@login).should be_nil
      end
    end
    context 'if the user login length is lower than 4' do
      before do
        @login = 'l<4'
      end
      it 'should return false' do
        User.new(:login => @login,:password => @password).save.should be_false
      end
      it 'should not store the user in memory' do
        User.new(:login => @login,:password => @password).save.should be_false
        User.find_by_login(@login).should be_nil
      end
    end
    context 'if the user password length is lower than 4' do
      before do
        @password = 'p<4'
      end
      it 'should return false' do
        User.new(:login => @login,:password => @password).save.should be_false
      end
      it 'should not store the user in memory' do
        User.new(:login => @login,:password => @password).save.should be_false
        User.find_by_login(@login).should be_nil
      end
    end
    context 'if the user password is greater than 15' do
      before do
        @password = 'password_greater_than_15'
      end
      it 'should return false' do
        User.new(:login => @login,:password => @password).save.should be_false
      end
      it 'should not store the user in memory' do
        User.new(:login => @login,:password => @password).save.should be_false
        User.find_by_login(@login).should be_nil
      end
    end
    context 'if the user login is unsused' do
      it 'should return true' do
        User.new(:login => @login,:password => @password).save.should be_true
      end
      it 'should store the user in memory' do
        User.new(:login => @login,:password => @password).save.should be_true
        User.find_by_login(@login).should be_true
      end
    end
    context 'if the user login is already used' do
      it 'should return false' do
        User.new(:login => @login,:password => @password).save.should be_true
        User.new(:login => @login,:password => @password).save.should be_false
      end
    end
  end
  describe 'memorize' do
    subject do
      User.new(:login => @login,:password => @password)      
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
  describe 'self.find_user' do
    before do
      User.new(:login => @login,:password => @password).save
    end
    context 'if parameters match with a user in the database' do
      it 'should return this user' do
        User.find_user(@login,@password).login.should == @login
      end
    end
    context 'if parameters do not match a user in the database' do
      it 'should return false' do
        User.find_user('other_login','other_password').should be_false
      end
    end
  end
  describe 'self.remember' do
    before do
      @sid = '1664'
      @request = double('Rack::Request')
      @request.stub(:cookies){ {'s_auth_id'=>@sid} }
    end
    context 'if request comes from a user previously memorized' do
      before do
        @user = \
        User.new(
                 :login => @login,
                 :password => @password,
                 :cookie => @sid
                 ).save
      end
      it 'should return this user' do
        User.remember(@request).should_not be_nil
        User.remember(@request).login.should == @login
      end
    end
    context 'if request comes from a user not memorized' do
      before do
        @user = \
        User.new(
                 :login => @login,
                 :password => @password,
                 :cookie => '51'
                 ).save
      end
      it 'should return nil' do
        User.remember(@request).should be_nil
      end
    end
  end
end
