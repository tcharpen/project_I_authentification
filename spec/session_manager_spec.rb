require 'rack'
require_relative '../lib/session_manager.rb'

describe SessionManager do
  subject do
    @session_id = 'session_id'
    SessionManager.new(@session_id)
  end
  describe 'initialize' do
    it 'should store a cookie name' do
      subject.session_id.should == @session_id
    end
  end
  describe 'session' do
    context 'The Rack::Request contains a cookie previously set by create_session' do
      before do
        response = Rack::Response.new
        subject.create_session(response)
        sid = response.header['Set-Cookie'].split('=')[1]
        @request = double('rack_request')
        @request.stub(:cookies) { {@session_id => sid} }
      end
      it 'should return the session' do
        subject.session(@request).should be_true
      end
    end
    context 'The Rack::Request does not contain a cookie previously set by create_session' do
      before do
        @request = double('rack_request')
        @request.stub(:cookies) { {@session_id => 'random_number'} }
      end
      it 'should return nil' do 
        subject.session(@request).should be_nil
      end
    end
  end
  describe 'create_session' do
    it 'should set a session_id cookie to a Rack::Response' do
      response = Rack::Response.new
      subject.create_session(response)
      response.header['Set-Cookie'].should_not be_nil
      response.header['Set-Cookie'].should match %r{.*#{@session_id}=.+}
     end
  end
end
