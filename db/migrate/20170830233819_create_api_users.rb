class CreateApiUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :api_users do |t|
      t.string :email
      t.string :api_key

      t.timestamps
    end
  end
end
