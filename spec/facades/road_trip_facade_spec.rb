require "rails_helper"

RSpec.describe RoadTripFacade do
  describe "initialize" do
    it "exists" do
      facade = RoadTripFacade.new

      expect(facade).to be_a(RoadTripFacade)
    end
  end

  describe "#get_road_trip_info" do
    it "returns a Road Trip object", :vcr do
      facade = RoadTripFacade.new
      road_trip = facade.get_road_trip_info("denver,co", "pueblo,co")

      expect(road_trip).to be_a(RoadTrip)
      expect(road_trip.start_city).to be_a(String)
      expect(road_trip.start_city).to eq("Denver") # should be Denver, CO
      expect(road_trip.end_city).to be_a(String)
      expect(road_trip.end_city).to eq("Pueblo") # should be Pueblo, CO 
      expect(road_trip.travel_time).to be_a(String)
      expect(road_trip.travel_time).to eq("01:45:23")
      expect(road_trip.weather_at_eta).to be_a(Hash)
      expect(road_trip.weather_at_eta[:datetime]).to be_a(String)
      expect(road_trip.weather_at_eta[:temperature]).to be_a(Float)
      expect(road_trip.weather_at_eta[:condition]).to be_a(String)
    end
  end
end