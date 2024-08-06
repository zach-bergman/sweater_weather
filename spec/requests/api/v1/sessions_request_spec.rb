require "rails_helper"

RSpec.describe "Sessions" do
  describe "POST /api/v1/sessions" do
    it "logs in a user and returns the user's api key" do
      # creating user first
      user_create_params = {
        email: "test@example.com",
        password: "password",
        password_confirmation: "password"
      }

      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/users", headers: headers, params: JSON.generate(user_create_params)

      # logging in user
      user_params = {
        email: "test@example.com",
        password: "password"
      }

      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/sessions", headers: headers, params: JSON.generate(user_params)

      expect(response).to be_successful
      expect(response.status).to eq(200)

      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response_body).to be_a(Hash)
      expect(response_body).to have_key(:data)
      expect(response_body[:data]).to be_a(Hash)
      expect(response_body[:data]).to have_key(:id)
      expect(response_body[:data][:id]).to be_a(String)
      expect(response_body[:data]).to have_key(:type)
      expect(response_body[:data][:type]).to eq("user")
      expect(response_body[:data]).to have_key(:attributes)
      expect(response_body[:data][:attributes]).to be_a(Hash)
      expect(response_body[:data][:attributes]).to have_key(:email)
      expect(response_body[:data][:attributes][:email]).to be_a(String)
      expect(response_body[:data][:attributes][:email]).to eq(User.last.email)
      expect(response_body[:data][:attributes]).to have_key(:api_key)
      expect(response_body[:data][:attributes][:api_key]).to be_a(String)
      expect(response_body[:data][:attributes][:api_key]).to eq(User.last.api_key)
      expect(response_body[:data][:attributes]).to_not have_key(:password)
    end

    describe "sad path" do
      it "returns an error if email does not exist" do
        # creating user first
        user_create_params = {
          email: "test@example.com",
          password: "password",
          password_confirmation: "password"
        }

        headers = {"CONTENT_TYPE" => "application/json"}

        post "/api/v1/users", headers: headers, params: JSON.generate(user_create_params)

        # logging in user
        user_params = {
          email: "testtt@example.com",
          password: "password"
        }

        headers = {"CONTENT_TYPE" => "application/json"}

        post "/api/v1/sessions", headers: headers, params: JSON.generate(user_params)

        expect(response).to_not be_successful
        expect(response.status).to eq(401)

        response_body = JSON.parse(response.body, symbolize_names: true)

        expect(response_body[:errors]).to be_a(Array)
        expect(response_body[:errors].first[:status]).to eq(401)
        expect(response_body[:errors].first[:message]).to eq("Invalid credentials")
      end

      it "returns an error if email is empty" do
        # creating user first
        user_create_params = {
          email: "test@example.com",
          password: "password",
          password_confirmation: "password"
        }

        headers = {"CONTENT_TYPE" => "application/json"}

        post "/api/v1/users", headers: headers, params: JSON.generate(user_create_params)

        # logging in user
        user_params = {
          email: "",
          password: "password"
        }

        headers = {"CONTENT_TYPE" => "application/json"}

        post "/api/v1/sessions", headers: headers, params: JSON.generate(user_params)

        expect(response).to_not be_successful
        expect(response.status).to eq(401)

        response_body = JSON.parse(response.body, symbolize_names: true)

        expect(response_body[:errors]).to be_a(Array)
        expect(response_body[:errors].first[:status]).to eq(401)
        expect(response_body[:errors].first[:message]).to eq("Invalid credentials")
      end

      it "returns an error if password is wrong" do
        # creating user first
        user_create_params = {
          email: "test@example.com",
          password: "password",
          password_confirmation: "password"
        }

        headers = {"CONTENT_TYPE" => "application/json"}

        post "/api/v1/users", headers: headers, params: JSON.generate(user_create_params)

        # logging in user
        user_params = {
          email: "test@example.com",
          password: "passwordddd"
        }

        headers = {"CONTENT_TYPE" => "application/json"}

        post "/api/v1/sessions", headers: headers, params: JSON.generate(user_params)

        expect(response).to_not be_successful
        expect(response.status).to eq(401)

        response_body = JSON.parse(response.body, symbolize_names: true)

        expect(response_body[:errors]).to be_a(Array)
        expect(response_body[:errors].first[:status]).to eq(401)
        expect(response_body[:errors].first[:message]).to eq("Invalid credentials")
      end

      it "returns an error if password is empty" do
        # creating user first
        user_create_params = {
          email: "test@example.com",
          password: "password",
          password_confirmation: "password"
        }

        headers = {"CONTENT_TYPE" => "application/json"}

        post "/api/v1/users", headers: headers, params: JSON.generate(user_create_params)

        # logging in user
        user_params = {
          email: "test@example.com",
          password: ""
        }

        headers = {"CONTENT_TYPE" => "application/json"}

        post "/api/v1/sessions", headers: headers, params: JSON.generate(user_params)

        expect(response).to_not be_successful
        expect(response.status).to eq(401)

        response_body = JSON.parse(response.body, symbolize_names: true)

        expect(response_body[:errors]).to be_a(Array)
        expect(response_body[:errors].first[:status]).to eq(401)
        expect(response_body[:errors].first[:message]).to eq("Invalid credentials")
      end
    end
  end
end