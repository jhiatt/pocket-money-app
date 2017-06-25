class CreateEventWeeklies < ActiveRecord::Migration[5.1]
  def change
    create_table :event_weeklies do |t|
      t.boolean :sunday
      t.boolean :monday
      t.boolean :tuesday
      t.boolean :wednesday
      t.boolean :thursday
      t.boolean :friday
      t.boolean :saturday

      t.timestamps
    end
  end
end
