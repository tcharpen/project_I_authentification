require 'active_record'

class Application < ActiveRecord::Base
  belongs_to :user
  has_many :connections

  validates :name, :uniqueness => true
  validates :name, :format => {:with => %r{^\w{4,}$} }
  validates :secret, :format => {:with => %r{^.{4,32}$}}
  validates :user, :presence => true
end

