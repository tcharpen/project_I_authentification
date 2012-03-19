require 'spec_helper'
require_relative '../lib/connection.rb'
require_relative '../database.rb'

describe Connection do
  it 'should have a user' do
    should respond_to(:user)
  end
  it 'should have an application' do
    should respond_to(:application)
  end
end
