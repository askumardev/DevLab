class Article < ApplicationRecord
  validates :title, presence: true

  has_many :sections, -> { order(position: :asc) }, dependent: :destroy, inverse_of: :article
  accepts_nested_attributes_for :sections, allow_destroy: true, reject_if: :all_blank
end
