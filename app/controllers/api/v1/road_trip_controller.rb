class Api::V1::RoadTripController < ApplicationController
  def create
    road_trip = RoadTripFacade.new.get_road_trip_info(road_trip_params[:origin], road_trip_params[:destination])
    render json: RoadTripSerializer.new(road_trip)
  end

  private

  def road_trip_params
    params.permit(:origin, :destination, :api_key)
  end
end