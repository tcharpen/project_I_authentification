require 'active_record'

class Application < ActiveRecord::Base
  belongs_to :user

  validates :name, :uniqueness => true
  validates :name, :format => {:with => %r{^\w{4,}$} }
  validates :url, :format => {:with => %r{^http:\/\/\w+(\.{1}\w+)?(:\d+)?(\/\w+)*\/?$} }
  validates :user, :presence => true
end

