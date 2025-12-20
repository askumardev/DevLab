class CreateLocations < ActiveRecord::Migration[7.2]
  def change
    create_table :locations do |t|
      t.string :state
      t.string :district
      t.string :pincode

      t.timestamps
    end
  end
end
