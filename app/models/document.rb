class Document < ApplicationRecord
  belongs_to :article, optional: true

  validates :name, presence: true

  # Active Storage attachment (new) — use `uploaded_file` to avoid collision with existing `file` column
  has_one_attached :uploaded_file

  # Helpers for file metadata and storage. Prefer Active Storage when attached,
  # fall back to legacy public/uploads filesystem fields for backward compatibility.
  def file_path
    return nil if uploaded_file.attached?
    return nil unless file.present?
    if folder.present?
      Rails.root.join('public', 'uploads', folder, file)
    else
      Rails.root.join('public', 'uploads', file)
    end
  end

  def url
    if uploaded_file.attached?
      Rails.application.routes.url_helpers.rails_blob_path(uploaded_file, only_path: true)
    else
      return nil unless file.present?
      if folder.present?
        "/uploads/#{folder}/#{file}"
      else
        "/uploads/#{file}"
      end
    end
  end

  def image?
    if uploaded_file.attached?
      uploaded_file.content_type.present? && uploaded_file.content_type.start_with?('image')
    else
      content_type.present? && content_type.start_with?('image')
    end
  end

  def human_size
    if uploaded_file.attached?
      ActiveSupport::NumberHelper.number_to_human_size(uploaded_file.byte_size)
    else
      return nil unless file_size
      ActiveSupport::NumberHelper.number_to_human_size(file_size)
    end
  end
end
