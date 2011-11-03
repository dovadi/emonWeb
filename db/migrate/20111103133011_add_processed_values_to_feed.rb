class AddProcessedValuesToFeed < ActiveRecord::Migration
  def change
    add_column :feeds, :processed_value_0, :decimal, :precision => 10, :scale => 2
    add_column :feeds, :processed_value_1, :decimal, :precision => 10, :scale => 2
    add_column :feeds, :processed_value_2, :decimal, :precision => 10, :scale => 2
    add_column :feeds, :processed_value_3, :decimal, :precision => 10, :scale => 2
  end
end