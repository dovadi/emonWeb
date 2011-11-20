class AddApiReadToken < ActiveRecord::Migration
  def up
    add_column :users, :api_read_token, :string
    add_index :users, :api_read_token, :unique => true
  end

  def down
    remove_index :users, :api_read_token
    remove_column :users, :api_read_token
  end
end