class RoadTripFacade
  def initialize
    @forecast_service = ForecastService.new
    @mapquest_service = MapquestService.new
  end

  def get_road_trip_info(origin, destination)
    mapquest_data = @mapquest_service.get_road_trip_info(origin, destination)
    coordinates = mapquest_data[:route][:locations].first[:latLng]
    coordinates_string = "#{coordinates[:lat]},#{coordinates[:lng]}"
    forecast_data = @forecast_service.get_forecast(coordinates_string)
    RoadTrip.new(mapquest_data, forecast_data)
  end
end