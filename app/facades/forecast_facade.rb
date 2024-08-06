class ForecastFacade
  def initialize
    @forecast_service = ForecastService.new
    @mapquest_service = MapquestService.new
  end

  def get_forecast(location)
    mapquest_data = @mapquest_service.get_lat_long(location)
    
    coordinates = mapquest_data[:results].first[:locations].first[:latLng]
    coordinates_string = "#{coordinates[:lat]},#{coordinates[:lng]}"

    forecast_data = @forecast_service.get_forecast(coordinates_string)

    Forecast.new(forecast_data)
  end
end