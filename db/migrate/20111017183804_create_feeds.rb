class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.decimal :value, :precision => 10, :scale => 2
      t.integer :user_id
      t.integer :input_id

      t.timestamps
    end
  end
end
