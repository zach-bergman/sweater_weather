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

      post "/api/v1/users", headers: headers, params: JSON.generate(user_params)

      created_user = User.last
      expect(created_user.email).to eq(user_params[:email])
      expect(created_user.authenticate(user_params[:password])).to eq(created_user)
      expect(created_user.api_key).to be_a(String)
      expect(created_user.api_key.length).to eq(24)

      expect(response).to be_successful
      expect(response.status).to eq(201)

      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response_body).to be_a(Hash)
      expect(response_body).to have_key(:data)
      expect(response_body[:data]).to be_a(Hash)
      expect(response_body[:data]).to have_key(:id)
      expect(response_body[:data][:id]).to be_a(String)
      expect(response_body[:data]).to have_key(:type)
      expect(response_body[:data][:type]).to eq("users")
      expect(response_body[:data]).to have_key(:attributes)
      expect(response_body[:data][:attributes]).to be_a(Hash)
      expect(response_body[:data][:attributes]).to have_key(:email)
      expect(response_body[:data][:attributes][:email]).to be_a(String)
      expect(response_body[:data][:attributes]).to have_key(:api_key)
      expect(response_body[:data][:attributes][:api_key]).to be_a(String)
      expect(response_body[:data][:attributes][:api_key]).to eq(created_user.api_key)
      
      # it does not return the password
      expect(response_body[:data]).to_not have_key(:password)
      expect(response_body[:data][:attributes]).to_not have_key(:password)
    end

    describe "sad path" do
      it "returns an error if email is not present or is taken" do
        user_params = {
          email: "",
          password: "password",
          password_confirmation: "password"
        }

        headers = {"CONTENT_TYPE" => "application/json"}

        post "/api/v1/users", headers: headers, params: JSON.generate(user_params)
    
        expect(response).to_not be_successful
        expect(response.status).to eq(400)
  
        response_body = JSON.parse(response.body, symbolize_names: true)

        expect(response_body[:errors]).to be_a(Array)
        expect(response_body[:errors].first[:status]).to eq(400)
        expect(response_body[:errors].first[:message]).to eq("Email can't be blank")
      end

      it "returns an error if email is not unique" do
        user_params = {
          email: "user_1@email.com",
          password: "password",
          password_confirmation: "password"
        }

        headers = {"CONTENT_TYPE" => "application/json"}

        post "/api/v1/users", headers: headers, params: JSON.generate(user_params)

        expect(response).to be_successful
        expect(response.status).to eq(201)

        user_params = {
          email: "user_1@email.com",
          password: "password",
          password_confirmation: "password"
        }

        headers = {"CONTENT_TYPE" => "application/json"}

        post "/api/v1/users", headers: headers, params: JSON.generate(user_params)

        expect(response).to_not be_successful
        expect(response.status).to eq(400)
  
        response_body = JSON.parse(response.body, symbolize_names: true)

        expect(response_body[:errors]).to be_a(Array)
        expect(response_body[:errors].first[:status]).to eq(400)
        expect(response_body[:errors].first[:message]).to eq("Email has already been taken")
      end

      it "returns an error if password is not present" do
        user_params = {
          email: "user_1@email.com",
          password: "",
          password_confirmation: "password"
        }

        headers = {"CONTENT_TYPE" => "application/json"}

        post "/api/v1/users", headers: headers, params: JSON.generate(user_params)
    
        expect(response).to_not be_successful
        expect(response.status).to eq(400)
  
        response_body = JSON.parse(response.body, symbolize_names: true)

        expect(response_body[:errors]).to be_a(Array)
        expect(response_body[:errors].first[:status]).to eq(400)
        expect(response_body[:errors].first[:message]).to eq("Password can't be blank, Password can't be blank, and Password is too short (minimum is 6 characters)")
      end

      it "returns an error if password is not longer than 6 characters" do
        user_params = {
          email: "user_1@email.com",
          password: "hi",
          password_confirmation: "hi"
        }

        headers = {"CONTENT_TYPE" => "application/json"}

        post "/api/v1/users", headers: headers, params: JSON.generate(user_params)
    
        expect(response).to_not be_successful
        expect(response.status).to eq(400)
  
        response_body = JSON.parse(response.body, symbolize_names: true)

        expect(response_body[:errors]).to be_a(Array)
        expect(response_body[:errors].first[:status]).to eq(400)
        expect(response_body[:errors].first[:message]).to eq("Password is too short (minimum is 6 characters)")
      end
      
      it "returns an error if passwords don't match" do
        user_params = {
          email: "user_1@email.com",
          password: "password",
          password_confirmation: "hi"
        }

        headers = {"CONTENT_TYPE" => "application/json"}

        post "/api/v1/users", headers: headers, params: JSON.generate(user_params)
    
        expect(response).to_not be_successful
        expect(response.status).to eq(400)
  
        response_body = JSON.parse(response.body, symbolize_names: true)

        expect(response_body[:errors]).to be_a(Array)
        expect(response_body[:errors].first[:status]).to eq(400)
        expect(response_body[:errors].first[:message]).to eq("Password confirmation doesn't match Password")
      end
    end
  end
end