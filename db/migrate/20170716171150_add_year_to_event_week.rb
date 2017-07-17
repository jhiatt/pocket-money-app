class AddYearToEventWeek < ActiveRecord::Migration[5.1]
  def change
    add_column :event_weeklies, :year, :string
  end
end
