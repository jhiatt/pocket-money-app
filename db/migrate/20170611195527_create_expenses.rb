class CreateExpenses < ActiveRecord::Migration[5.1]
  def change
    create_table :expenses do |t|

      t.datetime :date
      t.decimal :amount, precision: 8, scale: 2

      t.timestamps
    end
  end
end
