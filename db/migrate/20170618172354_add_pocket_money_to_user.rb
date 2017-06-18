class AddPocketMoneyToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :pocket_money, :decimal, precision: 10, scale: 2
  end
end
