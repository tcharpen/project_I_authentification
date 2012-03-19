class CreateConnections < ActiveRecord::Migration
  def up
    create_table :connections do |t|
      t.integer :user_id
      t.integer :application_id
    end
  end

  def down
    drop_table :connections
  end
end
