class AddIpAddressAndSerialNumberToUser < ActiveRecord::Migration
  def change
    add_column :users, :serial_number, :string
    add_column :users, :ip_address, :string
    add_index  :users, :serial_number, :unique => true
  end
end
