$: << File.dirname(__FILE__)
require 'active_record'

config = YAML::load( File.open( File.join('config','database.yml') ) )

config.each do |db_name,db_config|
  ActiveRecord::Base.establish_connection( db_config )
  ActiveRecord::Migration.verbose = true
  ActiveRecord::Migrator.migrate "db/migrate"
end

# sqlite3 db/devlopment.sqlite3
#
# .databases
# .tables
# .schema
# select * from schema_migrations
