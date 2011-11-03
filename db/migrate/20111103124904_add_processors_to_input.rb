class AddProcessorsToInput < ActiveRecord::Migration
  def change
    add_column :inputs, :processors, :string
  end
end