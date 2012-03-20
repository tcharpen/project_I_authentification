require_relative './lib/user.rb'
require_relative './lib/application.rb'
require_relative './lib/connection.rb'
require_relative 'database.rb' 

User.all.each{|u|u.destroy}
Application.all.each{|a|a.destroy}
Connection.all.each{|c|c.destroy}
User.create(:login => 'admin', :password => 'admin', :admin => true)
