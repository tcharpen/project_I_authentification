require 'active_record'

ENV['RACK_ENV'] ||= 'development'

config = YAML::load( File.open( File.join('config','database.yml') ) )
ActiveRecord::Base.establish_connection( config[ENV['RACK_ENV']] )
