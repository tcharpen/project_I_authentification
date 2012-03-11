# Handle a unique session for each user
class SessionManager
  
  attr_reader :session_id

  # create a SessionManager instance where
  # session_id will be the cookie name used
  # create and identify users session
  # (session_id must be a string)
  def initialize(session_id)
    @session_id = session_id
    @pool = {}
  end

  # A unique cookie will be generate and attach 
  # to rack_response (rack_response must be a 
  # Rack::Response instance) 
  def create_session(rack_response)
    sid = generate_cookie_id
    @pool[sid.to_s] = {}
    rack_response.set_cookie(@session_id,sid)
  end

  # return an id which is not used by another user
  def generate_cookie_id
    sid = 0
    loop do
      sid = rand(2**32-1)
      break unless @pool[sid]
    end
    sid
  end

  # return the session identify by the cookie in
  # rack_request (rack_request must be a 
  # Rack::Request instance).
  # if no cookie identify the user nil is return.
  def session(rack_request)
    sid = rack_request.cookies[@session_id]
    @pool[sid.to_s]
  end
end
