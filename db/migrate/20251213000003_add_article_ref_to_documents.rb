class AddArticleRefToDocuments < ActiveRecord::Migration[7.2]
  def change
    add_reference :documents, :article, foreign_key: true, index: true
  end
end
