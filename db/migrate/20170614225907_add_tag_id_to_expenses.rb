class AddTagIdToExpenses < ActiveRecord::Migration[5.1]
  def change
    add_column :expenses, :tag_id, :integer
  end
end
