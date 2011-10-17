class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.decimal :value, :precision => 10, :scale => 2
      t.integer :user_id
      t.integer :input_id

      t.timestamps
    end
    add_index :feeds, :user_id
    add_index :feeds, :input_id
  end
end