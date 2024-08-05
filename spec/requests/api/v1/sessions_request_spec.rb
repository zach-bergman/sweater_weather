require "rails_helper"

RSpec.describe "Sessions" do
  describe "POST /api/v1/sessions" do
    it "logs in a user and returns the user's api key" do
      user_params = {
        email: "user_1@email.com",
        password: "password"
      }

      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/sessions", headers: headers, params: JSON.generate(user_params)

      expect(response).to be_successful
      expect(response.status).to eq(201)

      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response_body).to be_a(Hash)
    end
  end
end