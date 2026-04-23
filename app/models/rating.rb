class Rating < ApplicationRecord
  belongs_to :rateable, polymorphic: true, optional: true

  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :score, presence: true, numericality: { greater_than_or_equal_to: 0.5, less_than_or_equal_to: 5, message: 'must be between 0.5 and 5' }
  validate :score_step

  scope :recent, -> { order(created_at: :desc) }

  def target_display
    if rateable.present?
      rateable_label = rateable.try(:title) || rateable.try(:name) || rateable.id
      "#{rateable.class.model_name.human}: #{rateable_label}"
    else
      page_name.presence || 'General'
    end
  end

  def star_display
    return '' if score.blank?

    value = score.to_f.round(1)
    full = value.floor
    half = (value * 2).to_i.odd?

    display = '★' * full
    display += '½' if half
    display += '☆' * (5 - full - (half ? 1 : 0))
    "#{display} (#{value})"
  end

  private

  def score_step
    return if score.blank?

    unless (score.to_f * 2).to_i == score.to_f * 2
      errors.add(:score, 'must be a whole or half star value')
    end
  end
end
