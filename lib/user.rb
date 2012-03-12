require 'active_record'

class User < ActiveRecord::Base
  validates :login, :length => { :minimum => 4 }
  validates :login, :uniqueness => true
  validates :password, :length => { :minimum => 4 }

  def self.find_user(login,password)
    User.where('login = ? AND password = ?', login, password).find_by_login(login)
  end

  def self.generate_cookie_id
    sid = 0
    loop do
      sid = rand(2**32-1)
      break if User.where('cookie = ?',sid).empty?
    end
    sid
  end

  def memorize(response)
    sid = User.generate_cookie_id
    self.cookie = sid
    self.save
    response.set_cookie('s_auth_id',sid)
  end

  def self.remember(request)
    sid = request.cookies['s_auth_id']
    User.find_by_cookie(sid.to_s)
  end
end
