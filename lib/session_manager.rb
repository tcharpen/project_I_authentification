class SessionManager
  attr_reader :session_id
  def initialize(session_id)
    @session_id = session_id
    @pool = {}
  end
  def create_session(rack_response)
    sid = generate_cookie_id
    @pool[sid.to_s] = {}
    rack_response.set_cookie(@session_id,sid)
  end
  def generate_cookie_id
    sid = 0
    loop do
      sid = rand(2**32-1)
      break unless @pool[sid]
    end
    sid
  end
  def session(rack_request)
    sid = rack_request.cookies[@session_id]
    @pool[sid.to_s]
  end
end


