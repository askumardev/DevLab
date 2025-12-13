# spec/requests/articles_spec.rb
require 'rails_helper'

RSpec.describe "Articles", type: :request do
  # Dummy headers to bypass any UA or browser checks
  let(:headers) { { "User-Agent" => "RSpec-Test" } }

  describe "GET /articles" do
    it "returns http success and lists articles" do
      Article.create!(title: "Spec Article", body: "Test body")

      get articles_path, headers: headers

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Spec Article")
    end
  end

  describe "GET /articles/:id" do
    it "returns http success for an existing article" do
      article = Article.create!(title: "Show Article", body: "Show body")

      get article_path(article), headers: headers

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Show Article")
      expect(response.body).to include("Show body")
    end
  end

  describe "POST /articles (with nested sections and file)" do
    it "creates an article, nested section and attaches uploaded file" do
      fixture = Rack::Test::UploadedFile.new(
        Rails.root.join('spec/fixtures/files/test.txt'),
        'text/plain'
      )

      post articles_path,
           params: {
             article: {
               title: "With Upload",
               body: "Article body",
               sections_attributes: {
                 "0" => { heading: "S1", content: "C1" }
               },
               new_files: [fixture],
               new_file_names: ["spec-file"]
             }
           },
           headers: headers

      # Check redirect to the created article
      expect(response).to redirect_to(article_path(Article.last))
      follow_redirect!
      expect(response.body).to include("With Upload")
      expect(Article.last.documents.count).to be >= 1
    end
  end

  describe "Other article actions" do
    it "renders new article form" do
      get new_article_path, headers: headers
      expect(response).to have_http_status(:ok)
    end

    it "renders edit form" do
      article = Article.create!(title: "E1", body: "B")
      get edit_article_path(article), headers: headers
      expect(response).to have_http_status(:ok)
    end

    it "updates an article" do
      article = Article.create!(title: "Old", body: "B")

      patch article_path(article),
            params: { article: { title: "New" } },
            headers: headers

      expect(response).to redirect_to(article_path(article))
      article.reload
      expect(article.title).to eq("New")
    end

    it "destroys an article" do
      article = Article.create!(title: "ToDelete", body: "X")

      expect {
        delete article_path(article), headers: headers
      }.to change(Article, :count).by(-1)

      expect(response).to redirect_to(articles_path)
    end
  end
end
