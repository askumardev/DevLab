class DocumentUploader
  class << self
    class UploadError < StandardError; end

    MAX_FILE_SIZE = 20.megabytes
    ALLOWED_MIME_TYPES = [
      /^image\//,
      'application/pdf',
      'application/msword',
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      'application/vnd.ms-excel',
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      'text/plain'
    ]

    def store(uploaded, name: nil, article: nil)
      raise UploadError, 'No file uploaded' unless uploaded.respond_to?(:original_filename)

      orig = uploaded.original_filename
      ctype = uploaded.content_type
      size = uploaded.size if uploaded.respond_to?(:size)

      validate_upload!(orig, ctype, size)
      # Prefer Active Storage attachment when available. Create the DB record
      # and attach the uploaded IO to `uploaded_file` (new ActiveStorage attachment).
      document = Document.create(
        name: name.presence || orig,
        original_filename: orig,
        content_type: ctype,
        file_size: size,
        folder: nil,
        file: nil,
        article: article
      )

      begin
        io = uploaded.respond_to?(:tempfile) ? uploaded.tempfile : StringIO.new(uploaded.read)
        document.uploaded_file.attach(io: io, filename: orig, content_type: ctype)
      rescue => e
        # If attaching fails, cleanup and surface error
        document.destroy rescue nil
        raise UploadError, "Failed to attach file: #{e.message}"
      end

      document
    end

    def replace(document, uploaded, name: nil)
      raise UploadError, 'No file uploaded' unless uploaded.respond_to?(:original_filename)

      orig = uploaded.original_filename
      ctype = uploaded.content_type
      size = uploaded.size if uploaded.respond_to?(:size)

      validate_upload!(orig, ctype, size)

      # remove legacy filesystem file if present
      if document.file_path && File.exist?(document.file_path)
        File.delete(document.file_path) rescue nil
      end

      # If Active Storage attachment exists, purge it and attach the new file.
      if document.uploaded_file.attached?
        document.uploaded_file.purge_later
      end

      begin
        io = uploaded.respond_to?(:tempfile) ? uploaded.tempfile : StringIO.new(uploaded.read)
        document.uploaded_file.attach(io: io, filename: orig, content_type: ctype)
      rescue => e
        raise UploadError, "Failed to attach file: #{e.message}"
      end

      document.update(
        name: name.presence || orig,
        original_filename: orig,
        content_type: ctype,
        file_size: size,
        folder: nil,
        file: nil
      )

      document
    end

    private

    def classify_folder(content_type)
      return 'files' unless content_type.present?
      if content_type.start_with?("image")
        'images'
      elsif content_type == 'application/pdf'
        'pdfs'
      else
        'files'
      end
    end

    def generate_safe_filename(orig)
      ext = File.extname(orig)
      base = SecureRandom.hex(10)
      "#{base}#{ext}"
    end

    def validate_upload!(orig, content_type, size)
      if size && size > MAX_FILE_SIZE
        raise UploadError, "File too large (max #{MAX_FILE_SIZE / 1.megabyte} MB)"
      end

      return if content_type.blank?

      allowed = ALLOWED_MIME_TYPES.any? do |m|
        m.is_a?(Regexp) ? content_type.match?(m) : content_type == m
      end

      raise UploadError, "Unsupported file type: #{content_type}" unless allowed
    end
  end
end
