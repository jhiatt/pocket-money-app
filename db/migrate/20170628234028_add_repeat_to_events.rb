class AddRepeatToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :repeat, :boolean
  end
end
