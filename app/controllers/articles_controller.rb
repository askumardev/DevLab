class ArticlesController < ApplicationController
  # run set_article for actions that need an existing record
  before_action :set_article, only: %i[show edit update destroy]

  def index
    @articles = Article.order(id: :asc)
  end

  def show
  end

  def new
    @article = Article.new
    # build one section by default for the nested form
    @article.sections.build
  end

  def create
    # create article first, then handle any uploaded files provided in params
    # Filter out upload-specific keys so they are not mass-assigned to Article
    attrs = article_params.except(:new_file_names, :new_files, :remove_document_ids, :existing_document_ids)
    @article = Article.new(attrs)
    if @article.save
      failures = process_new_files(@article)
      @article.reload
      if failures.any?
        redirect_to @article, notice: "Article was created, but some files failed to upload: #{failures.join('; ')}"
      else
        redirect_to @article, notice: "Article was successfully created."
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    attrs = article_params.except(:new_file_names, :new_files, :remove_document_ids, :existing_document_ids)
    if @article.update(attrs)
      process_removed_documents(@article)
      failures = process_new_files(@article)
      @article.reload
      if failures.any?
        redirect_to @article, notice: "Article updated, but some files failed to upload: #{failures.join('; ')}"
      else
        redirect_to @article, notice: "Article was successfully updated."
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
  @article.destroy
  redirect_to articles_path, notice: "Article was successfully destroyed."
  end

  private

  def set_article
    @article = Article.includes(:documents, :sections).find(params[:id])

  end

  def article_params
    params.require(:article).permit(
      :title,
      :body,
      sections_attributes: [:id, :heading, :content, :position, :_destroy],
      new_file_names: [],
      new_files: [],
      remove_document_ids: [],
      existing_document_ids: []
    )
  end

  # handle array of newly added files from the article form
  def process_new_files(article)
    return [] unless params[:article]
    files = params[:article][:new_files] || []
    names = params[:article][:new_file_names] || []
    failures = []

    Array(files).each_with_index do |uploaded, idx|
      next unless uploaded.respond_to?(:original_filename)
      name = names[idx].presence
      begin
        DocumentUploader.store(uploaded, name: name, article: article)
      rescue DocumentUploader::UploadError => e
        failures << "#{name || uploaded.original_filename}: #{e.message}"
      end
    end

    failures
  end

  # remove documents selected for deletion from the article form
  def process_removed_documents(article)
    ids = params[:article][:remove_document_ids] || []
    Array(ids).each do |id|
      doc = article.documents.find_by(id: id)
      next unless doc
      if doc.file_path && File.exist?(doc.file_path)
        File.delete(doc.file_path) rescue nil
      end
      doc.destroy
    end
  end

  # reuse document filename generation utility (same as DocumentsController)
  # (file generation delegated to DocumentUploader)
end
