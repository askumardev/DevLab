class Car < ApplicationRecord
  validates :brand, :model, presence: true
end
