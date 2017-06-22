class CreateAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts do |t|
      t.decimal :last_balance, precision: 10, scale: 2
      t.decimal :pocket_money, precision: 10, scale: 2
      t.integer :pocket_time

      t.timestamps
    end
  end
end
