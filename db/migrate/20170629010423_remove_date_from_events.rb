class RemoveDateFromEvents < ActiveRecord::Migration[5.1]
  def change
    remove_column :events, :date, :datetime
  end
end
