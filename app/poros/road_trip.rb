require "time"

class RoadTrip
  attr_reader :start_city,
              :end_city,
              :travel_time,
              :weather_at_eta

  def initialize(mapquest_data, forecast_data)
    @start_city = mapquest_data[:route][:locations].first[:adminArea5]
    @end_city = mapquest_data[:route][:locations].last[:adminArea5]
    @travel_time = mapquest_data[:route][:legs].first[:formattedTime]
    @weather_at_eta = format_weather(forecast_data)
  end

  # if drive is under 24 hours, hourly weather. if drive is over 24 hours, use daily weather.
  def eta_time
    current_time = Time.now
    
    time_parts = @travel_time.split(':')
    
    hours = time_parts[0].to_i
    minutes = time_parts[1].to_i
    seconds = time_parts[2].to_i
    
    total_travel_seconds = (hours * 3600) + (minutes * 60) + seconds
    
    estimated_arrival_time = current_time + total_travel_seconds
    
    estimated_arrival_time
  end

  def format_weather(forecast_data)
    eta = eta_time
    current_time = Time.now
    travel_seconds = eta - current_time

    # Check if travel time is less than or greater than 24 hours
    if travel_seconds < 24 * 3600 # 24 hours in seconds
      find_hourly_weather(forecast_data, eta)
    else
      find_daily_weather(forecast_data, eta)
    end
  end

  # Method to find hourly weather at ETA
  def find_hourly_weather(forecast_data, eta)
    hourly_forecast = forecast_data[:forecast][:forecastday].first[:hour]

    forecast_at_eta = hourly_forecast.find do |hourly_data|
      Time.parse(hourly_data[:time]) >= eta
    end

    if forecast_at_eta
      {
        datetime: forecast_at_eta[:time],
        temperature: forecast_at_eta[:temp_f],
        condition: forecast_at_eta[:condition][:text]
      }
    else
      { error: 'No hourly weather data available for ETA' }
    end
  end

  # Method to find daily weather for the arrival day
  def find_daily_weather(forecast_data, eta)
    daily_forecast = forecast_data[:forecast][:forecastday]

    forecast_at_eta = daily_forecast.find do |daily_data|
      Date.parse(daily_data[:date]) == eta.to_date
    end
    
    if forecast_at_eta
      {
        datetime: forecast_at_eta[:date],
        temperature: forecast_at_eta[:day][:avgtemp_f],
        condition: forecast_at_eta[:day][:condition][:text]
      }
    else
      { error: 'No daily weather data available for ETA' }
    end
  end
end