class Url < ApplicationRecord
  before_create :generate_short_code

  validates :original_url, presence: true
  validates :short_code, uniqueness: true

  private

  def generate_short_code
    loop do
      self.short_code = SecureRandom.alphanumeric(6)
      break unless Url.exists?(short_code: short_code)
    end
  end
end
