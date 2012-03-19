class AddUserIdToApplications < ActiveRecord::Migration
  def up
    add_column :applications, :user_id, :integer
  end

  def down
    remove_column :users, :user_id
  end
end
