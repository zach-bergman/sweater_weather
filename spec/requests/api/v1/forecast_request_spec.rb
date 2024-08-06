require "rails_helper"

RSpec.describe "Forecast API" do
  describe "GET /api/v1/forecast?location=denver,co" do
    it "responds with the serialized Forecast json for a given location", :vcr do
      get "/api/v1/forecast?location=denver,co"

      expect(response).to be_successful
      # test for things NOT being sent in the response
      forecast = JSON.parse(response.body, symbolize_names: true)

      expect(forecast).to be_a(Hash)
      expect(forecast).to have_key(:data)
      expect(forecast[:data]).to be_a(Hash)
      expect(forecast[:data]).to have_key(:id)
      expect(forecast[:data][:id]).to eq("null")
      expect(forecast[:data]).to have_key(:type)
      expect(forecast[:data][:type]).to eq("forecast")
      expect(forecast[:data]).to have_key(:attributes)
      expect(forecast[:data][:attributes]).to be_a(Hash)

      # current weather
      expect(forecast[:data][:attributes]).to have_key(:current_weather)
      expect(forecast[:data][:attributes][:current_weather]).to be_a(Hash)
      expect(forecast[:data][:attributes][:current_weather]).to have_key(:last_updated)
      expect(forecast[:data][:attributes][:current_weather][:last_updated]).to be_a(String)
      expect(forecast[:data][:attributes][:current_weather]).to have_key(:temperature)
      expect(forecast[:data][:attributes][:current_weather][:temperature]).to be_a(Float)
      expect(forecast[:data][:attributes][:current_weather]).to have_key(:feels_like)
      expect(forecast[:data][:attributes][:current_weather][:feels_like]).to be_a(Float)
      expect(forecast[:data][:attributes][:current_weather]).to have_key(:humidity)
      expect(forecast[:data][:attributes][:current_weather][:humidity]).to be_a(Integer)
      expect(forecast[:data][:attributes][:current_weather]).to have_key(:uvi)
      expect(forecast[:data][:attributes][:current_weather][:uvi]).to be_a(Float)
      expect(forecast[:data][:attributes][:current_weather]).to have_key(:visibility)
      expect(forecast[:data][:attributes][:current_weather][:visibility]).to be_a(Float)
      expect(forecast[:data][:attributes][:current_weather]).to have_key(:condition)
      expect(forecast[:data][:attributes][:current_weather][:condition]).to be_a(String)
      expect(forecast[:data][:attributes][:current_weather]).to have_key(:icon)
      expect(forecast[:data][:attributes][:current_weather][:icon]).to be_a(String)

      # daily weather
      expect(forecast[:data][:attributes]).to have_key(:daily_weather)
      expect(forecast[:data][:attributes][:daily_weather]).to be_an(Array)
      expect(forecast[:data][:attributes][:daily_weather].count).to eq(5)

      forecast[:data][:attributes][:daily_weather].each do |day|
        expect(day).to be_a(Hash)
        expect(day).to have_key(:date)
        expect(day[:date]).to be_a(String)
        expect(day).to have_key(:sunrise)
        expect(day[:sunrise]).to be_a(String)
        expect(day).to have_key(:sunset)
        expect(day[:sunset]).to be_a(String)
        expect(day).to have_key(:max_temp)
        expect(day[:max_temp]).to be_a(Float)
        expect(day).to have_key(:min_temp)
        expect(day[:min_temp]).to be_a(Float)
        expect(day).to have_key(:condition)
        expect(day[:condition]).to be_a(String)
        expect(day).to have_key(:icon)
        expect(day[:icon]).to be_a(String)
      end

      # hourly weather
      expect(forecast[:data][:attributes]).to have_key(:hourly_weather)
      expect(forecast[:data][:attributes][:hourly_weather]).to be_an(Array)
      expect(forecast[:data][:attributes][:hourly_weather].count).to eq(24)

      forecast[:data][:attributes][:hourly_weather].each do |hour|
        expect(hour).to have_key(:time)
        expect(hour[:time]).to be_a(String)
        expect(hour).to have_key(:temperature)
        expect(hour[:temperature]).to be_a(Float)
        expect(hour).to have_key(:conditions)
        expect(hour[:conditions]).to be_a(String)
        expect(hour).to have_key(:icon)
        expect(hour[:icon]).to be_a(String)
      end

      # data not sent
      expect(forecast[:data]).to_not have_key(:location)
      expect(forecast[:data][:attributes][:current_weather]).to_not have_key(:temp_c)
      expect(forecast[:data][:attributes][:current_weather]).to_not have_key(:wind_mph)
      expect(forecast[:data][:attributes][:current_weather]).to_not have_key(:wind_kph)
    end

    it "(sad) returns an error message for empty search", :vcr do
      get "/api/v1/forecast?location="
      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      
      forecast = JSON.parse(response.body, symbolize_names: true)

      expect(forecast).to be_a(Hash)
      expect(forecast).to have_key(:errors)
      expect(forecast[:errors].first).to have_key(:message)
      expect(forecast[:errors].first[:message]).to eq("City and state is required.")
      expect(forecast[:errors].first).to have_key(:status)
      expect(forecast[:errors].first[:status]).to eq(400)
    end
  end
end