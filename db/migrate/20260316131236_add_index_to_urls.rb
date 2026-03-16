class AddIndexToUrls < ActiveRecord::Migration[7.2]
  def change
    add_index :urls, :short_code, unique: true
  end
end
