class AddBalanceUpdateTimeToAccount < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :balance_update_time, :datetime
  end
end
