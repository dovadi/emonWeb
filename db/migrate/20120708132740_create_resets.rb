class CreateResets < ActiveRecord::Migration
  def change
    create_table :resets do |t|
      t.integer :user_id
      t.string  :reason

      t.timestamps
    end
    add_index :resets, :user_id
  end
end
