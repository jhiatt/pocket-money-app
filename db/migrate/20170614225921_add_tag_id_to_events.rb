class AddTagIdToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :tag_id, :integer
  end
end
