class Comment < ApplicationRecord
  belongs_to :article

  before_validation :set_default_author

  validates :body, presence: true

  private

  def set_default_author
    self.author = "Anonymous" if author.blank?
  end
end
