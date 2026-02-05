require 'rails_helper'

RSpec.describe "Experiences", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/experience/index"
      expect(response).to have_http_status(:success)
    end
  end

end
