class CreateRatings < ActiveRecord::Migration[7.0]
  def change
    create_table :ratings do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.integer :score, null: false
      t.text :comment
      t.string :rateable_type
      t.bigint :rateable_id
      t.string :page_name

      t.timestamps
    end

    add_index :ratings, [:rateable_type, :rateable_id]
    add_index :ratings, :page_name
  end
end
