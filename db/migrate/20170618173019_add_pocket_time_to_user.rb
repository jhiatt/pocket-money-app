class AddPocketTimeToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :pocket_time, :integer
  end
end
