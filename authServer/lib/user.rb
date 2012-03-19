require 'active_record'

class User < ActiveRecord::Base
  has_many :applications
  has_many :connections

  validates :login, :format => { :with => %r{^\w{4,15}$} }
  validates :login, :uniqueness => true
  validates :password, :length => { :minimum => 4, :maximum => 15 }

  def self.find_user(login,password)
    User.where('login = ? AND password = ?', login, password).find_by_login(login)
  end
end
