class ChangeRatingScoreToDecimal < ActiveRecord::Migration[7.0]
  def up
    change_column :ratings, :score, :decimal, precision: 3, scale: 1, null: false
  end

  def down
    change_column :ratings, :score, :integer, null: false
  end
end
