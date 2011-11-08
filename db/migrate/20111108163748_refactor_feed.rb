class RefactorFeed < ActiveRecord::Migration
  def up
    remove_column :feeds, :processed_value_0
    remove_column :feeds, :processed_value_1
    remove_column :feeds, :processed_value_2
    remove_column :feeds, :processed_value_3
    change_column :feeds, :value, :float
    rename_column :feeds, :value, :last_value
    add_column    :feeds, :name, :string
    change_column :inputs, :last_value, :float
  end

  def down
  end
end