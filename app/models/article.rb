class Article < ApplicationRecord
  validates :title, presence: true

  has_many :sections, -> { order(position: :asc) }, dependent: :destroy, inverse_of: :article
  accepts_nested_attributes_for :sections, allow_destroy: true, reject_if: :all_blank

  has_many :documents, dependent: :destroy, inverse_of: :article
  has_many :comments, dependent: :destroy, inverse_of: :article

  def comments_count
    attributes["comments_count"].to_i
  end
end
