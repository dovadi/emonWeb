class CreateInputs < ActiveRecord::Migration
  def change
    create_table :inputs do |t|
      t.string :name
      t.decimal :last_value, :precision => 10, :scale => 2
      t.integer :user_id

      t.timestamps
    end
    add_index :inputs, :user_id
  end
end