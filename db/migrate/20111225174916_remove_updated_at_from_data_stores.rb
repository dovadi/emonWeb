class RemoveUpdatedAtFromDataStores < ActiveRecord::Migration
  def up
    remove_column :data_stores, :updated_at
  end

  def down
  end
end
