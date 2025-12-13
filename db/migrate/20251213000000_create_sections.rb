class CreateSections < ActiveRecord::Migration[7.2]
  def change
    create_table :sections do |t|
      t.references :article, null: false, foreign_key: true
      t.string :heading
      t.text :content
      t.integer :position

      t.timestamps
    end
  end
end
