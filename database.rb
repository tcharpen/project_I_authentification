require 'active_record'

config = YAML::load( File.open( File.join('config','database.yml') ) )
ActiveRecord::Base.establish_connection( config["development"] )
