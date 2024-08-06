require "rails_helper"

RSpec.describe "Road Trip API" do
  describe "POST /api/v1/road_trip" do
    it "responds with the serialized Road Trip json for a given location", :vcr do
      user = User.create!(email: "arealemail@email.com", password: "password", password_confirmation: "password")

      road_trip_params = {
        origin: "Denver,CO",
        destination: "Pueblo,CO",
        api_key: user.api_key
      }

      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/road_trip", headers: headers, params: JSON.generate(road_trip_params)

      expect(response).to be_successful
      expect(response.status).to eq(200)

      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response_body).to be_a(Hash)
      expect(response_body).to have_key(:data)
      expect(response_body[:data]).to be_a(Hash)
      expect(response_body[:data]).to have_key(:id)
      expect(response_body[:data][:id]).to eq("null")
      expect(response_body[:data]).to have_key(:type)
      expect(response_body[:data][:type]).to eq("road_trip")
      expect(response_body[:data]).to have_key(:attributes)
      expect(response_body[:data][:attributes]).to be_a(Hash)
      expect(response_body[:data][:attributes]).to have_key(:start_city)
      expect(response_body[:data][:attributes][:start_city]).to be_a(String)
      expect(response_body[:data][:attributes][:start_city]).to eq("Denver")
      expect(response_body[:data][:attributes]).to have_key(:end_city)
      expect(response_body[:data][:attributes][:end_city]).to be_a(String)
      expect(response_body[:data][:attributes][:end_city]).to eq("Pueblo")
      expect(response_body[:data][:attributes]).to have_key(:travel_time)
      expect(response_body[:data][:attributes][:travel_time]).to be_a(String)
      expect(response_body[:data][:attributes]).to have_key(:weather_at_eta)
      expect(response_body[:data][:attributes][:weather_at_eta]).to be_a(Hash)
      expect(response_body[:data][:attributes][:weather_at_eta]).to have_key(:datetime)
      expect(response_body[:data][:attributes][:weather_at_eta][:datetime]).to be_a(String)
      expect(response_body[:data][:attributes][:weather_at_eta]).to have_key(:temperature)
      expect(response_body[:data][:attributes][:weather_at_eta][:temperature]).to be_a(Float)
      expect(response_body[:data][:attributes][:weather_at_eta]).to have_key(:condition)
      expect(response_body[:data][:attributes][:weather_at_eta][:condition]).to be_a(String)
    end

    describe "responds with daily weather forecast if travel time is over 24 hours" do
      it "responds with the serialized Road Trip json for a given location - NY to LA", :vcr do
        user = User.create!(email: "arealemail@email.com", password: "password", password_confirmation: "password")

        road_trip_params = {
          origin: "New York, NY",
          destination: "Los Angeles, CA",
          api_key: user.api_key
        }

        headers = {"CONTENT_TYPE" => "application/json"}

        post "/api/v1/road_trip", headers: headers, params: JSON.generate(road_trip_params)

        expect(response).to be_successful
        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body, symbolize_names: true)

        expect(response_body).to be_a(Hash)
        expect(response_body).to have_key(:data)
        expect(response_body[:data]).to be_a(Hash)
        expect(response_body[:data]).to have_key(:id)
        expect(response_body[:data][:id]).to eq("null")
        expect(response_body[:data]).to have_key(:type)
        expect(response_body[:data][:type]).to eq("road_trip")
        expect(response_body[:data]).to have_key(:attributes)
        expect(response_body[:data][:attributes]).to be_a(Hash)
        expect(response_body[:data][:attributes]).to have_key(:start_city)
        expect(response_body[:data][:attributes][:start_city]).to be_a(String)
        expect(response_body[:data][:attributes][:start_city]).to eq("New York")
        expect(response_body[:data][:attributes]).to have_key(:end_city)
        expect(response_body[:data][:attributes][:end_city]).to be_a(String)
        expect(response_body[:data][:attributes][:end_city]).to eq("Los Angeles")
        expect(response_body[:data][:attributes]).to have_key(:travel_time)
        expect(response_body[:data][:attributes][:travel_time]).to be_a(String)
        expect(response_body[:data][:attributes]).to have_key(:weather_at_eta)
        expect(response_body[:data][:attributes][:weather_at_eta]).to be_a(Hash)
        expect(response_body[:data][:attributes][:weather_at_eta]).to have_key(:datetime)
        expect(response_body[:data][:attributes][:weather_at_eta][:datetime]).to be_a(String)
        expect(response_body[:data][:attributes][:weather_at_eta][:datetime]).to eq("2024-08-08")
        expect(response_body[:data][:attributes][:weather_at_eta]).to have_key(:temperature)
        expect(response_body[:data][:attributes][:weather_at_eta][:temperature]).to be_a(Float)
        expect(response_body[:data][:attributes][:weather_at_eta]).to have_key(:condition)
        expect(response_body[:data][:attributes][:weather_at_eta][:condition]).to be_a(String)
      end

      it "responds with the serialized Road Trip json for a given location - NY to Panama", :vcr do
        user = User.create!(email: "arealemail@email.com", password: "password", password_confirmation: "password")

        road_trip_params = {
          origin: "New York, NY",
          destination: "Panama City, Panama",
          api_key: user.api_key
        }

        headers = {"CONTENT_TYPE" => "application/json"}

        post "/api/v1/road_trip", headers: headers, params: JSON.generate(road_trip_params)

        expect(response).to be_successful
        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body, symbolize_names: true)

        expect(response_body).to be_a(Hash)
        expect(response_body).to have_key(:data)
        expect(response_body[:data]).to be_a(Hash)
        expect(response_body[:data]).to have_key(:id)
        expect(response_body[:data][:id]).to eq("null")
        expect(response_body[:data]).to have_key(:type)
        expect(response_body[:data][:type]).to eq("road_trip")
        expect(response_body[:data]).to have_key(:attributes)
        expect(response_body[:data][:attributes]).to be_a(Hash)
        expect(response_body[:data][:attributes]).to have_key(:start_city)
        expect(response_body[:data][:attributes][:start_city]).to be_a(String)
        expect(response_body[:data][:attributes][:start_city]).to eq("New York")
        expect(response_body[:data][:attributes]).to have_key(:end_city)
        expect(response_body[:data][:attributes][:end_city]).to be_a(String)
        expect(response_body[:data][:attributes][:end_city]).to eq("Ciudad de Panamá")
        expect(response_body[:data][:attributes]).to have_key(:travel_time)
        expect(response_body[:data][:attributes][:travel_time]).to be_a(String)
        expect(response_body[:data][:attributes]).to have_key(:weather_at_eta)
        expect(response_body[:data][:attributes][:weather_at_eta]).to be_a(Hash)
        expect(response_body[:data][:attributes][:weather_at_eta]).to have_key(:datetime)
        expect(response_body[:data][:attributes][:weather_at_eta][:datetime]).to be_a(String)
        expect(response_body[:data][:attributes][:weather_at_eta][:datetime]).to eq("2024-08-09")
        expect(response_body[:data][:attributes][:weather_at_eta]).to have_key(:temperature)
        expect(response_body[:data][:attributes][:weather_at_eta][:temperature]).to be_a(Float)
        expect(response_body[:data][:attributes][:weather_at_eta]).to have_key(:condition)
        expect(response_body[:data][:attributes][:weather_at_eta][:condition]).to be_a(String)
      end

      it "weather block should be empty and travel time should be “impossible” - NY to London, UK", :vcr do
        user = User.create!(email: "arealemail@email.com", password: "password", password_confirmation: "password")

        road_trip_params = {
          origin: "New York, NY",
          destination: "London, UK",
          api_key: user.api_key
        }

        headers = {"CONTENT_TYPE" => "application/json"}

        post "/api/v1/road_trip", headers: headers, params: JSON.generate(road_trip_params)

        expect(response).to_not be_successful
        expect(response.status).to eq(400)

        response_body = JSON.parse(response.body, symbolize_names: true)

        expect(response_body).to be_a(Hash)
        expect(response_body).to have_key(:data)
        expect(response_body[:data]).to be_a(Hash)
        expect(response_body[:data]).to have_key(:id)
        expect(response_body[:data][:id]).to eq("null")
        expect(response_body[:data]).to have_key(:type)
        expect(response_body[:data][:type]).to eq("road_trip")
        expect(response_body[:data]).to have_key(:attributes)
        expect(response_body[:data][:attributes]).to be_a(Hash)
        expect(response_body[:data][:attributes]).to have_key(:start_city)
        expect(response_body[:data][:attributes][:start_city]).to eq(nil)
        expect(response_body[:data][:attributes]).to have_key(:end_city)
        expect(response_body[:data][:attributes][:end_city]).to eq(nil)
        expect(response_body[:data][:attributes]).to have_key(:travel_time)
        expect(response_body[:data][:attributes][:travel_time]).to be_a(String)
        expect(response_body[:data][:attributes][:travel_time]).to eq("impossible")
        expect(response_body[:data][:attributes]).to have_key(:weather_at_eta)
        expect(response_body[:data][:attributes][:weather_at_eta]).to be_a(Hash)
        expect(response_body[:data][:attributes][:weather_at_eta]).to be_empty
      end
    end

    describe "sad path" do
      it "returns an error if api_key is not present", :vcr do
        user = User.create!(email: "arealemail@email.com", password: "password", password_confirmation: "password")
  
        road_trip_params = {
          origin: "Denver,CO",
          destination: "Pueblo,CO",
          api_key: ""
        }
  
        headers = {"CONTENT_TYPE" => "application/json"}
  
        post "/api/v1/road_trip", headers: headers, params: JSON.generate(road_trip_params)
  
        expect(response).to_not be_successful
        expect(response.status).to eq(422)
  
        response_body = JSON.parse(response.body, symbolize_names: true)
  
        expect(response_body).to be_a(Hash)
        expect(response_body).to have_key(:errors)
        expect(response_body[:errors]).to be_a(Array)
        expect(response_body[:errors].first[:status]).to eq(422)
        expect(response_body[:errors].first[:message]).to eq("Missing parameters")
      end

      it "returns an error if api_key is not valid", :vcr do
        user = User.create!(email: "arealemail@email.com", password: "password", password_confirmation: "password")
  
        road_trip_params = {
          origin: "Denver,CO",
          destination: "Pueblo,CO",
          api_key: "notavalidkey"
        }
  
        headers = {"CONTENT_TYPE" => "application/json"}
  
        post "/api/v1/road_trip", headers: headers, params: JSON.generate(road_trip_params)
  
        expect(response).to_not be_successful
        expect(response.status).to eq(401)
  
        response_body = JSON.parse(response.body, symbolize_names: true)
  
        expect(response_body).to be_a(Hash)
        expect(response_body).to have_key(:errors)
        expect(response_body[:errors]).to be_a(Array)
        expect(response_body[:errors].first[:status]).to eq(401)
        expect(response_body[:errors].first[:message]).to eq("Invalid API key")
      end

      it "returns an error if origin is not present", :vcr do
        user = User.create!(email: "arealemail@email.com", password: "password", password_confirmation: "password")
  
        road_trip_params = {
          origin: "",
          destination: "Pueblo,CO",
          api_key: user.api_key
        }
  
        headers = {"CONTENT_TYPE" => "application/json"}
  
        post "/api/v1/road_trip", headers: headers, params: JSON.generate(road_trip_params)
  
        expect(response).to_not be_successful
        expect(response.status).to eq(422)
  
        response_body = JSON.parse(response.body, symbolize_names: true)
  
        expect(response_body).to be_a(Hash)
        expect(response_body).to have_key(:errors)
        expect(response_body[:errors]).to be_a(Array)
        expect(response_body[:errors].first[:status]).to eq(422)
        expect(response_body[:errors].first[:message]).to eq("Missing parameters")
      end

      it "returns an error if destination is not present", :vcr do
        user = User.create!(email: "arealemail@email.com", password: "password", password_confirmation: "password")
  
        road_trip_params = {
          origin: "Denver, CO",
          destination: "",
          api_key: user.api_key
        }
  
        headers = {"CONTENT_TYPE" => "application/json"}
  
        post "/api/v1/road_trip", headers: headers, params: JSON.generate(road_trip_params)
  
        expect(response).to_not be_successful
        expect(response.status).to eq(422)
  
        response_body = JSON.parse(response.body, symbolize_names: true)
  
        expect(response_body).to be_a(Hash)
        expect(response_body).to have_key(:errors)
        expect(response_body[:errors]).to be_a(Array)
        expect(response_body[:errors].first[:status]).to eq(422)
        expect(response_body[:errors].first[:message]).to eq("Missing parameters")
      end
    end
  end
end