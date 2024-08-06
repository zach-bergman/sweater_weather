require "rails_helper"

RSpec.describe RoadTrip do
  it "exists", :vcr do
    mapquest_service = MapquestService.new
    forecast_service = ForecastService.new

    mapquest_data = mapquest_service.get_road_trip_info("denver,co", "pueblo,co")
    forecast_data = forecast_service.get_forecast("38.2542,-104.6091")

    road_trip = RoadTrip.new(mapquest_data, forecast_data)
    
    expect(road_trip).to be_a(RoadTrip)
    expect(road_trip.start_city).to be_a(String)
    expect(road_trip.end_city).to be_a(String)
    expect(road_trip.travel_time).to be_a(String)
    expect(road_trip.weather_at_eta).to be_a(Hash)
    expect(road_trip.weather_at_eta[:datetime]).to be_a(String)
    expect(road_trip.weather_at_eta[:temperature]).to be_a(Float)
    expect(road_trip.weather_at_eta[:condition]).to be_a(String)
  end

  # it "exists with impossible route", :vcr do
  # end

  # describe "#eta_time" do
  #   it "returns a Time object", :vcr do

  #   end
  # end
end