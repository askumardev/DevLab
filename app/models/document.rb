class Document < ApplicationRecord
  belongs_to :article, optional: true

  validates :name, presence: true

  # Helpers for file metadata and storage
  def file_path
    return nil unless file.present?
    if folder.present?
      Rails.root.join('public', 'uploads', folder, file)
    else
      Rails.root.join('public', 'uploads', file)
    end
  end

  def url
    return nil unless file.present?
    if folder.present?
      "/uploads/#{folder}/#{file}"
    else
      "/uploads/#{file}"
    end
  end

  def image?
    content_type.present? && content_type.start_with?('image')
  end

  def human_size
    return nil unless file_size
    ActiveSupport::NumberHelper.number_to_human_size(file_size)
  end
end
