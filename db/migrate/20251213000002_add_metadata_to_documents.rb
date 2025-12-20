class AddMetadataToDocuments < ActiveRecord::Migration[7.2]
  def change
    add_column :documents, :original_filename, :string
    add_column :documents, :content_type, :string
    add_column :documents, :file_size, :integer
    add_column :documents, :folder, :string
  end
end
