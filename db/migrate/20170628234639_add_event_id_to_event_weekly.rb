class AddEventIdToEventWeekly < ActiveRecord::Migration[5.1]
  def change
    add_column :event_weeklies, :event_id, :integer
  end
end
