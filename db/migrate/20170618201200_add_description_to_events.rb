class AddDescriptionToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :description, :string
  end
end
