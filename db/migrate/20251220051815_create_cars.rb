class CreateCars < ActiveRecord::Migration[7.2]
  def change
    create_table :cars do |t|
      t.string :brand
      t.string :model
      t.decimal :price
      t.integer :year

      t.timestamps
    end
  end
end
