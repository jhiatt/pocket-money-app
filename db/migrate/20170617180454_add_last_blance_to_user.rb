class AddLastBlanceToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :last_balance, :decimal, precision: 10, scale: 2

  end
end
