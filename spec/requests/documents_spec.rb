require 'rails_helper'

RSpec.describe "Documents", type: :request do
  let(:fixture_file) { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/test.txt'), 'text/plain') }

  describe 'POST /documents (multi-file)' do
    it 'accepts multiple uploaded files and redirects with notice' do
      post documents_path, params: { documents: { new_files: [fixture_file, fixture_file], new_file_names: ['one','two'] } }

      expect(response).to redirect_to(documents_path)
      follow_redirect!
      expect(response.body).to include('Uploaded')
      expect(Document.count).to be >= 1
    end
  end

  describe 'POST /documents (single file)' do
    it 'creates a single document and redirects to its show page' do
      post documents_path, params: { document: { name: 'single', file: fixture_file } }

      # controller redirects to created doc
      expect(response).to redirect_to(document_path(Document.last))
    end
  end

  describe 'other document actions' do
    before do
      host! 'www.example.com'
    end
    it 'renders index and shows existing documents' do
      d = Document.create!(name: 'D1')
      get documents_path
      # debug: show response for CI failures
      puts "DEBUG: status=#{response.status}"
      puts response.body[0..800]
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('D1')
    end

    it 'renders new document form' do
      get new_document_path
      expect(response).to have_http_status(:ok)
    end

    it 'shows a document' do
      d = Document.create!(name: 'ShowDoc')
      get document_path(d)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('ShowDoc')
    end

    it 'renders edit form for document' do
      d = Document.create!(name: 'EditDoc')
      get edit_document_path(d)
      expect(response).to have_http_status(:ok)
    end

    it 'updates document metadata (and optionally replaces file)' do
      d = Document.create!(name: 'OldName')
      patch document_path(d), params: { document: { name: 'UpdatedName' } }
      expect(response).to redirect_to(document_path(d))
      d.reload
      expect(d.name).to eq('UpdatedName')
    end

    it 'destroys a document' do
      d = Document.create!(name: 'ToDel')
      expect { delete document_path(d) }.to change(Document, :count).by(-1)
      expect(response).to redirect_to(documents_path)
    end
  end
end
