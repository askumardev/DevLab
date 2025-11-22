require 'rails_helper'

RSpec.describe "Articles", type: :request do
  describe "GET /articles" do
    it "returns http success and lists articles" do
      Article.create!(title: "Spec Article", body: "Test body")

      get articles_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Spec Article")
    end
  end

  describe "GET /articles/:id" do
    it "returns http success for an existing article" do
      article = Article.create!(title: "Show Article", body: "Show body")

      get article_path(article)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Show Article")
      expect(response.body).to include("Show body")
    end
  end
end
