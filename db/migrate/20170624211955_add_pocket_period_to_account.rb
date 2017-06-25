class AddPocketPeriodToAccount < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :pocket_period, :datetime
  end
end
