class AddTinyUrlColumnToUrls < ActiveRecord::Migration[7.2]
  def change
    add_column :urls, :tiny_url, :string
  end
end
