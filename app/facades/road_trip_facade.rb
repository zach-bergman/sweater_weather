class RoadTripFacade
  def initialize
    @forecast_service = ForecastService.new
    @mapquest_service = MapquestService.new
  end

  def get_road_trip_info(origin, destination)
    mapquest_data = @mapquest_service.get_road_trip_info(origin, destination)

    if mapquest_data[:info][:statuscode] != 0
      handle_route_error(mapquest_data)
    else    
      coordinates = mapquest_data[:route][:locations][1][:latLng]
      coordinates_string = "#{coordinates[:lat]},#{coordinates[:lng]}"
      forecast_data = @forecast_service.get_forecast(coordinates_string)
      RoadTrip.new(mapquest_data, forecast_data)
    end
  end

  def handle_route_error(mapquest_data)
    {
      data: {
        id: "null",
        type: "road_trip",
        attributes: {
          start_city: nil,
          end_city: nil,
          travel_time: "impossible",
          weather_at_eta: {}
        }
      }
    }
  end
end