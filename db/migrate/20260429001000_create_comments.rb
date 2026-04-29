class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.references :article, null: false, foreign_key: true
      t.string :author
      t.text :body, null: false

      t.timestamps
    end
  end
end
