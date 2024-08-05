require "rails_helper"

RSpec.describe MapquestService do
  describe "initialize" do
    it "exists" do
      service = MapquestService.new

      expect(service).to be_a(MapquestService)
    end
  end

  describe "#conn" do
    it "creates a Faraday connection" do
      connection = MapquestService.new.conn

      expect(connection).to be_a(Faraday::Connection)

      expect(connection.url_prefix.to_s).to eq("https://www.mapquestapi.com/")
      expect(connection.params["key"]).to eq(Rails.application.credentials.mapquest[:key])
    end
  end

  describe "#get_url" do
    it "returns the results from the Mapquest API for given URL", :vcr do
      response = MapquestService.new.get_url("geocoding/v1/address?location=denver,co")

      expect(response).to be_a(Hash)
      
      expect(response[:results].first[:locations].first[:latLng]).to have_key(:lat)
      expect(response[:results].first[:locations].first[:latLng][:lat]).to be_a(Float)
      expect(response[:results].first[:locations].first[:latLng]).to have_key(:lng)
      expect(response[:results].first[:locations].first[:latLng][:lng]).to be_a(Float)
    end
  end

  describe "#get_lat_long" do
    it "returns the lat and long for a given location", :vcr do
      response = MapquestService.new.get_lat_long("denver,co")

      expect(response).to be_a(Hash)
      
      expect(response[:results].first[:locations].first[:latLng]).to have_key(:lat)
      expect(response[:results].first[:locations].first[:latLng][:lat]).to be_a(Float)
      expect(response[:results].first[:locations].first[:latLng][:lat]).to eq(39.74001)
      
      expect(response[:results].first[:locations].first[:latLng]).to have_key(:lng)
      expect(response[:results].first[:locations].first[:latLng][:lng]).to be_a(Float)
      expect(response[:results].first[:locations].first[:latLng][:lng]).to eq(-104.99202)
    end

    it "(sad) returns 400 status an message for empty search", :vcr do
      response = MapquestService.new.get_lat_long("")

      expect(response).to be_a(Hash)
      expect(response).to have_key(:info)
      expect(response[:info]).to have_key(:statuscode)
      expect(response[:info][:statuscode]).to eq(400)
      expect(response[:info]).to have_key(:messages)
      expect(response[:info][:messages]).to be_an(Array)
      expect(response[:info][:messages].first).to eq("Illegal argument from request: Insufficient info for location")
    end

    it "(sad) returns empty data for a non city search", :vcr do
      response = MapquestService.new.get_lat_long("hsdfg")

      expect(response).to be_a(Hash)
      expect(response[:results]).to be_an(Array)

      expect(response[:results].first[:locations]).to be_an(Array)
      expect(response[:results].first[:locations].first).to be_a(Hash)
      expect(response[:results].first[:locations].first).to have_key(:adminArea5)
      expect(response[:results].first[:locations].first[:adminArea5]).to eq("")
      expect(response[:results].first[:locations].first).to have_key(:adminArea4)
      expect(response[:results].first[:locations].first[:adminArea5]).to eq("")
      expect(response[:results].first[:locations].first).to have_key(:adminArea3)
      expect(response[:results].first[:locations].first[:adminArea5]).to eq("")
    end
  end
end