class CreateApplications < ActiveRecord::Migration
  def up
    create_table :applications do |t|
      t.string :name
      t.string :secret
    end
  end

  def down
    drop_table :applications
  end
end
