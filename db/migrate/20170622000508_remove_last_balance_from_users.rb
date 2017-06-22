class RemoveLastBalanceFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :last_balance, :decimal
    remove_column :users, :pocket_money, :decimal
    remove_column :users, :pocket_time, :integer

  end
end
