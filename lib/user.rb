require 'active_record'

class User < ActiveRecord::Base
  validates :login, :length => { :minimum => 4 }
  validates :login, :uniqueness => true
  validates :password, :length => { :minimum => 4 }

  def self.find_user(login,password)
    User.where('login = ? AND password = ?', login, password).find_by_login(login)
  end

  def memorize(response)
    sid = 0
    loop do
      self.cookie = sid
      break if self.save
    end
    response.set_cookie('s_auth_id',sid)
  end

  def self.remember(request)
    sid = request.cookies['s_auth_id']
    User.find_by_cookie(sid.to_s)
  end
end
