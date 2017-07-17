class ChangePocketPeriodToInteger < ActiveRecord::Migration[5.1]
  def change
    change_column :accounts, :pocket_period, :integer
  end
end
