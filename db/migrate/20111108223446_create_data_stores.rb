class CreateDataStores < ActiveRecord::Migration
  def change
    create_table :data_stores do |t|
      t.float :value
      t.timestamps
    end
  end
end
