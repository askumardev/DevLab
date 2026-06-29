# app/models/appointment.rb
class Appointment < ApplicationRecord
  validates :start_time, :end_time, presence: true
  validates :title, presence: true

  scope :past, -> { where("end_time < ?", Time.current) }
  scope :upcoming, -> { where("start_time >= ?", Time.current) }

  validate :cannot_edit_past

  def cannot_edit_past
    if persisted? && end_time_was < Time.current
      errors.add(:base, "Cannot edit past appointments")
    end
  end
end
