class AddCookieToUsers < ActiveRecord::Migration
  def up
    add_column :users, :cookie, :string
  end

  def down
    remove_column :users, :cookie
  end
end
