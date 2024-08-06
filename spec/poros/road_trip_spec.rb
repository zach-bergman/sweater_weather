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

  describe "#eta_time" do
    it "returns a Time object", :vcr do
      current_time = Time.now
      travel_time = "01:30:00"
    
      time_parts = travel_time.split(':')

      expect(time_parts.count).to eq(3)
      expect(time_parts.first).to be_a(String)
      expect(time_parts.second).to be_a(String)
      expect(time_parts.third).to be_a(String)
      expect(time_parts).to eq(["01", "30", "00"])
    
      hours = time_parts[0].to_i
      minutes = time_parts[1].to_i
      seconds = time_parts[2].to_i

      expect(hours).to be_a(Integer)
      expect(minutes).to be_a(Integer)
      expect(seconds).to be_a(Integer)
      
      total_travel_seconds = (hours * 3600) + (minutes * 60) + seconds

      expect(total_travel_seconds).to be_an(Integer)
      expect(total_travel_seconds).to eq(5400)
      
      estimated_arrival_time = current_time + total_travel_seconds

      expect(estimated_arrival_time).to be_a(Time)
      expect(estimated_arrival_time).to be > current_time
    end
  end

  describe "#format_weather" do
    it "returns a hash of hourly weather data if travel time is less than 24 hours", :vcr do
      mapquest_service = MapquestService.new
      forecast_service = ForecastService.new
  
      mapquest_data = mapquest_service.get_road_trip_info("denver,co", "pueblo,co")
      forecast_data = forecast_service.get_forecast("38.2542,-104.6091")
  
      road_trip = RoadTrip.new(mapquest_data, forecast_data)

      eta = road_trip.eta_time
      current_time = Time.now
      travel_seconds = eta - current_time

      hourly_weather = road_trip.format_weather(forecast_data)

      expect(hourly_weather).to be_a(Hash)
      expect(hourly_weather).to have_key(:datetime)
      expect(hourly_weather[:datetime]).to be_a(String)
      expect(hourly_weather).to have_key(:temperature)
      expect(hourly_weather[:temperature]).to be_a(Float)
      expect(hourly_weather).to have_key(:condition)
      expect(hourly_weather[:condition]).to be_a(String)
    end

    it "returns a hash of daily weather data if travel time is greater than 24 hours", :vcr do
      mapquest_service = MapquestService.new
      forecast_service = ForecastService.new
  
      mapquest_data = mapquest_service.get_road_trip_info("New York, NY", "Los Angeles, CA")
      forecast_data = forecast_service.get_forecast("34.05223,-118.2426")
  
      road_trip = RoadTrip.new(mapquest_data, forecast_data)

      eta = road_trip.eta_time
      current_time = Time.now
      travel_seconds = eta - current_time

      daily_weather = road_trip.format_weather(forecast_data)

      expect(daily_weather).to be_a(Hash)
      expect(daily_weather).to have_key(:datetime)
      expect(daily_weather[:datetime]).to be_a(String)
      expect(daily_weather).to have_key(:temperature)
      expect(daily_weather[:temperature]).to be_a(Float)
      expect(daily_weather).to have_key(:condition)
      expect(daily_weather[:condition]).to be_a(String)
    end
  end

  describe "#find_hourly_weather" do
    it "returns a hash of hourly weather data at ETA", :vcr do
      mapquest_service = MapquestService.new
      forecast_service = ForecastService.new
  
      mapquest_data = mapquest_service.get_road_trip_info("Denver, CO", "Pueblo, CO")
      forecast_data = forecast_service.get_forecast("38.2542,-104.6091")
  
      road_trip = RoadTrip.new(mapquest_data, forecast_data)

      eta = road_trip.eta_time

      hourly_weather = road_trip.find_hourly_weather(forecast_data, eta)

      expect(hourly_weather).to be_a(Hash)
      expect(hourly_weather).to have_key(:datetime)
      expect(hourly_weather[:datetime]).to be_a(String)
      expect(hourly_weather).to have_key(:temperature)
      expect(hourly_weather[:temperature]).to be_a(Float)
      expect(hourly_weather).to have_key(:condition)
      expect(hourly_weather[:condition]).to be_a(String)
      expect(hourly_weather).to_not have_key(:error)
    end
  end

  describe "#find_daily_weather" do
    it "returns a hash of daily weather data at ETA", :vcr do
      mapquest_service = MapquestService.new
      forecast_service = ForecastService.new

      mapquest_data = mapquest_service.get_road_trip_info("New York, NY", "Los Angeles, CA")
      forecast_data = forecast_service.get_forecast("34.05223,-118.2426")
  
      road_trip = RoadTrip.new(mapquest_data, forecast_data)

      eta = road_trip.eta_time

      daily_weather = road_trip.find_daily_weather(forecast_data, eta)

      expect(daily_weather).to be_a(Hash)
      expect(daily_weather).to have_key(:datetime)
      expect(daily_weather[:datetime]).to be_a(String)
      expect(daily_weather).to have_key(:temperature)
      expect(daily_weather[:temperature]).to be_a(Float)
      expect(daily_weather).to have_key(:condition)
      expect(daily_weather[:condition]).to be_a(String)
      expect(daily_weather).to_not have_key(:error)
    end
  end
end