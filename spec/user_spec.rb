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
end
