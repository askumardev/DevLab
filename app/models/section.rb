class Section < ApplicationRecord
  belongs_to :article, inverse_of: :sections

  validates :heading, presence: false
  validates :content, presence: false
end
