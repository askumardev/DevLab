class CreateAppointments < ActiveRecord::Migration[7.2]
  def change
    create_table :appointments do |t|
      t.string :title
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end
