# -*- coding: utf-8 -*-
require 'spec_helper'
require_relative '../lib/application.rb'
require_relative '../lib/user.rb'
require_relative '../database.rb'

describe Application do
  before do
    User.all.each { |u| u.destroy }    
    Application.all.each { |a| a.destroy }
    @user = User.new(:login => 'toto', :password => '1234')
    @name = 'toto'
    @secret = 'secret'
  end
  let(:newApp1){Application.new(:name => @name, :secret => @secret, :user => @user)}  
  let(:newApp2){Application.new(:name => @name, :secret => @secret, :user => @user)}
  after do 
    User.all.each { |u| u.destroy }    
    Application.all.each { |a| a.destroy }
  end
  it 'should have a name' do
    should respond_to(:name)
  end
  it 'should have a secret' do
    should respond_to(:secret)
  end
  it 'should have a user' do
    should respond_to(:user)
  end
  it 'should have many connections' do
    should respond_to(:connections)
  end
  describe 'name' do
    it 'should always exists' do
      @name = ''
      newApp1.valid?.should be_false
    end
    it 'should looks like an application name' do
      @name = '?§&^#'
      newApp1.valid?.should be_false      
    end
    it 'should be unique' do
      newApp1.save.should be_true
      newApp2.valid?.should be_false
    end
  end
  describe 'secret' do
    it 'should always exists' do 
      @secret = ''
      newApp1.valid?.should be_false
    end
  end
  describe 'user' do
    it 'should always exists' do
      @user = nil
      newApp1.valid?.should be_false
    end
  end
end
