require 'active_record'

class User < ActiveRecord::Base
  validates :login, :length => { :minimum => 4 }
  validates :login, :uniqueness => true

  def self.find_user(login)
    User.find_by_login(login)
    # Why do not directly used find_by_login ?
    # cause when we will implement the password
    # this function will be more complicated
  end
end
