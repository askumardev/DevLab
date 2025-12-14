require 'rails_helper'

RSpec.describe "Chats", type: :request do
  describe "GET /room" do
    it "returns http success" do
      get "/chats/room"
      expect(response).to have_http_status(:success)
    end
  end

end
