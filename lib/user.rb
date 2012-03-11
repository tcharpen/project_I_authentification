require 'active_record'

class User < ActiveRecord::Base
  validates :login, :length => { :minimum => 4 }
  validates :login, :uniqueness => true
  validates :password, :length => { :minimum => 4 }

  def self.find_user(login,password)
    User.where('login = ? AND password = ?', login, password).find_by_login(login)
  end
end
