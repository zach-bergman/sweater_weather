require "rails_helper"

RSpec.describe Forecast do
  it "exists with correct weather data", :vcr do
    denver = ForecastService.new.get_forecast("39.74001,-104.99202")
    forecast = Forecast.new(denver)

    expect(forecast).to be_a(Forecast)

    expect(forecast.id).to eq(nil)

    # current weather
    expect(forecast.current_weather).to be_a(Hash)
    expect(forecast.current_weather).to have_key(:last_updated)
    expect(forecast.current_weather[:last_updated]).to be_a(String)
    expect(forecast.current_weather).to have_key(:temperature)
    expect(forecast.current_weather[:temperature]).to be_a(Float)
    expect(forecast.current_weather).to have_key(:feels_like)
    expect(forecast.current_weather[:feels_like]).to be_a(Float)
    expect(forecast.current_weather).to have_key(:humidity)
    expect(forecast.current_weather[:humidity]).to be_a(Integer)
    expect(forecast.current_weather).to have_key(:uvi)
    expect(forecast.current_weather[:uvi]).to be_a(Float)
    expect(forecast.current_weather).to have_key(:visibility)
    expect(forecast.current_weather[:visibility]).to be_a(Float)
    expect(forecast.current_weather).to have_key(:condition)
    expect(forecast.current_weather[:condition]).to be_a(String)
    expect(forecast.current_weather).to have_key(:icon)
    expect(forecast.current_weather[:icon]).to be_a(String)

    expect(forecast.current_weather).to_not have_key(:last_updated_epoch)
    expect(forecast.current_weather).to_not have_key(:temp_c)
    expect(forecast.current_weather).to_not have_key(:is_day)
    expect(forecast.current_weather).to_not have_key(:wind_mph)
    expect(forecast.current_weather).to_not have_key(:wind_kph)
    expect(forecast.current_weather).to_not have_key(:wind_degree)
    expect(forecast.current_weather).to_not have_key(:wind_dir)
    expect(forecast.current_weather).to_not have_key(:pressure_mb)
    expect(forecast.current_weather).to_not have_key(:pressure_in)
    expect(forecast.current_weather).to_not have_key(:precip_mm)
    expect(forecast.current_weather).to_not have_key(:precip_in)
    expect(forecast.current_weather).to_not have_key(:cloud)
    expect(forecast.current_weather).to_not have_key(:feelslike_c)
    expect(forecast.current_weather).to_not have_key(:windchill_c)
    expect(forecast.current_weather).to_not have_key(:windchill_f)
    expect(forecast.current_weather).to_not have_key(:heatindex_c)
    expect(forecast.current_weather).to_not have_key(:heatindex_f)
    expect(forecast.current_weather).to_not have_key(:dewpoint_c)
    expect(forecast.current_weather).to_not have_key(:dewpoint_f)
    expect(forecast.current_weather).to_not have_key(:vis_km)
    expect(forecast.current_weather).to_not have_key(:vis_miles)
    expect(forecast.current_weather).to_not have_key(:gust_mph)
    expect(forecast.current_weather).to_not have_key(:gust_kph)

    # daily weather
    expect(forecast.daily_weather).to be_an(Array)
    expect(forecast.daily_weather.count).to eq(5)

    forecast.daily_weather.each do |day|
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
    expect(forecast.hourly_weather).to be_an(Array)
    expect(forecast.hourly_weather.count).to eq(24)
    
    forecast.hourly_weather.each do |hour|
      expect(hour).to have_key(:time)
      expect(hour[:time]).to be_a(String)
      expect(hour).to have_key(:temperature)
      expect(hour[:temperature]).to be_a(Float)
      expect(hour).to have_key(:conditions)
      expect(hour[:conditions]).to be_a(String)
      expect(hour).to have_key(:icon)
      expect(hour[:icon]).to be_a(String)
    end
  end
end