require "rails_helper"

RSpec.describe ForecastService do
  describe "initialize" do
    it "exists" do
      service = ForecastService.new

      expect(service).to be_a(ForecastService)
    end
  end

  describe "#conn" do
    it "creates a Faraday connection" do
      connection = ForecastService.new.conn

      expect(connection).to be_a(Faraday::Connection)

      expect(connection.url_prefix.to_s).to eq("http://api.weatherapi.com/")
      expect(connection.params["key"]).to eq(Rails.application.credentials.forecast[:key])
    end
  end

  describe "#get_url" do
    it "returns the results from the Mapquest API for given URL", :vcr do
      response = ForecastService.new.get_url("v1/forecast.json?q=39.74001,-104.99202&days=5")

      expect(response).to be_a(Hash)
      #continue to test?
    end
  end

  describe "#get_forecast" do
    it "returns the forecast for a given location", :vcr do
      response = ForecastService.new.get_forecast("39.74001,-104.99202")

      expect(response).to be_a(Hash)
      #continue to test?
    end

    it "(sad) returns error message for empty search", :vcr do
      response = ForecastService.new.get_forecast("")

      expect(response).to be_a(Hash)
      expect(response).to have_key(:error)
      expect(response[:error]).to have_key(:code)
      expect(response[:error][:code]).to eq(1003)
      expect(response[:error]).to have_key(:message)
      expect(response[:error][:message]).to eq("Parameter q is missing.")
    end

    it "(sad) returns error message for weird coords search", :vcr do
      response = ForecastService.new.get_forecast("9999,9999")

      expect(response).to be_a(Hash)
      expect(response).to have_key(:error)
      expect(response[:error]).to have_key(:code)
      expect(response[:error][:code]).to eq(1006)
      expect(response[:error]).to have_key(:message)
      expect(response[:error][:message]).to eq("No matching location found.")
    end
  end
end