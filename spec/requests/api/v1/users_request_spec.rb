require "rails_helper"

RSpec.describe "Users" do
  describe "POST /api/v1/users" do
    it "creates a new user and saves in database" do
      user_params = {
        email: "user_1@email.com",
        password: "password",
        password_confirmation: "password"
      }

      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/users", headers: headers, params: JSON.generate(user: user_params)

      created_user = User.last
      binding.pry
    end
  end
end