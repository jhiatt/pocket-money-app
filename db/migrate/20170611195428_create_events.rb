class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.datetime :date
      t.decimal :frequency, precision: 4, scale: 2
      t.decimal :amount, precision: 8, scale: 2
      t.string :impact

      t.timestamps
    end
  end
end
