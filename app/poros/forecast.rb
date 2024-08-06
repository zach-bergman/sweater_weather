class Forecast
  attr_reader :current_weather,
              :daily_weather,
              :hourly_weather
              
  def initialize(data)
    @current_weather = Forecast.current_weather(data[:current])
    @daily_weather = Forecast.daily_weather(data[:forecast][:forecastday])
    @hourly_weather = Forecast.hourly_weather(data[:forecast][:forecastday])
  end

  def self.current_weather(current_data)
    {
      last_updated: current_data[:last_updated],
      temperature: current_data[:temp_f],
      feels_like: current_data[:feelslike_f],
      humidity: current_data[:humidity],
      uvi: current_data[:uv],
      visibility: current_data[:vis_miles],
      condition: current_data[:condition][:text],
      icon: current_data[:condition][:icon]
    }
  end

  def self.daily_weather(daily_data)
    daily_data.map do |day|
      {
        date: day[:date],
        sunrise: day[:astro][:sunrise],
        sunset: day[:astro][:sunset],
        max_temp: day[:day][:maxtemp_f],
        min_temp: day[:day][:mintemp_f],
        condition: day[:day][:condition][:text],
        icon: day[:day][:condition][:icon]
      }
    end
  end

  def self.hourly_weather(hourly_data)
    hourly_data.map do |data|
      data[:hour].map do |hour|
        {
          time: hour[:time],
          temperature: hour[:temp_f],
          conditions: hour[:condition][:text],
          icon: hour[:condition][:icon]
        }
      end
    end.first
  end
end