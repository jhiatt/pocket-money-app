class RemoveFrequencyFromAccounts < ActiveRecord::Migration[5.1]
  def change
    remove_column :events, :frequency, :decimal
  end
end
