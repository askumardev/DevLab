require 'rails_helper'

RSpec.describe "Home", type: :request do
  describe "GET /" do
    it "returns http success and contains welcome text" do
      get root_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Welcome to DevLab")
    end
  end
end
