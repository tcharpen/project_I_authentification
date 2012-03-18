require_relative './lib/user.rb'
require_relative 'database.rb' 

User.create(:login => 'admin', :password => 'admin', :admin => true)
