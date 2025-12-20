class DocumentsController < ApplicationController
  before_action :set_document, only: [:show, :edit, :update, :destroy]

  def index
    @documents = Document.order(created_at: :desc)
  end

  def new
    @document = Document.new
  end

  def create
    # Support uploading multiple files via documents[new_files][] from nested form
    if params[:documents] && params[:documents][:new_files].present?
      created = []
      files = Array(params[:documents][:new_files])
      names = Array(params[:documents][:new_file_names])
      failures = []
      files.each_with_index do |uploaded, idx|
        begin
          doc = ::DocumentUploader.store(uploaded, name: names[idx], article: nil)
          created << doc if doc
        rescue ::DocumentUploader::UploadError => e
          failures << "#{names[idx].presence || uploaded.original_filename}: #{e.message}"
        end
      end

      if created.any?
        notice = "Uploaded #{created.size} document(s)."
        notice += " Some files failed: #{failures.join('; ')}" if failures.any?
        redirect_to documents_path, notice: notice
      else
        flash.now[:alert] = failures.present? ? failures.join('; ') : 'No valid files to upload.'
        @document = Document.new
        render :new, status: :unprocessable_entity
      end
    else
      # fallback to single-file upload via document[file]
      @document = Document.new(document_params.except(:file))

      uploaded = document_params[:file]
      if uploaded.respond_to?(:original_filename)
        begin
          doc = ::DocumentUploader.store(uploaded, name: @document.name)
          if doc
            redirect_to doc, notice: 'Document uploaded.' and return
          end
        rescue ::DocumentUploader::UploadError => e
          flash.now[:alert] = e.message
        end
      end

      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    # allow updating name and replacing the file
    begin
      if params[:document] && params[:document][:file].present?
        ::DocumentUploader.replace(@document, params[:document][:file], name: params[:document][:name])
      else
        @document.name = params[:document][:name] if params[:document] && params[:document][:name]
        @document.save
      end

      if @document.errors.empty?
        redirect_to @document, notice: 'Document updated.'
      else
        render :edit, status: :unprocessable_entity
      end
    rescue ::DocumentUploader::UploadError => e
      flash.now[:alert] = e.message
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # remove file from disk if present
    if @document.file_path && File.exist?(@document.file_path)
      File.delete(@document.file_path) rescue nil
    end
    @document.destroy
    redirect_to documents_path, notice: 'Document deleted.'
  end

  private

  def set_document
    @document = Document.find(params[:id])
  end

  def document_params
    params.require(:document).permit(:name, :file)
  end
end
