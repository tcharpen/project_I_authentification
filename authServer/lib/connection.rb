require 'active_record'

class Connection < ActiveRecord::Base
  belongs_to :user
  belongs_to :application
end

