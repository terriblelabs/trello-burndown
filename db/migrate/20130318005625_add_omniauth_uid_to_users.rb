class AddOmniauthUidToUsers < ActiveRecord::Migration
  def change
    add_column :users, :uid, :string
    add_column :users, :username, :string
  end
end
