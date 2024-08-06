class Api::V1::RoadTripController < ApplicationController
  before_action :validate_request

  def create
    road_trip = RoadTripFacade.new.get_road_trip_info(road_trip_params[:origin], road_trip_params[:destination])
    if road_trip.class == Hash
      render json: road_trip, status: :bad_request
    else
      render json: RoadTripSerializer.new(road_trip)
    end
  end

  private

  def road_trip_params
    params.permit(:origin, :destination, :api_key)
  end

  def validate_request
    if missing_parameters?
      render json: ErrorSerializer.new(ErrorMessage.new("Missing parameters", 422)).serialize_json, status: :unprocessable_entity
    elsif invalid_api_key?
      render json: ErrorSerializer.new(ErrorMessage.new("Invalid API key", 401)).serialize_json, status: :unauthorized
    end
  end

  def missing_parameters?
    road_trip_params[:api_key].blank? || road_trip_params[:origin].blank? || road_trip_params[:destination].blank?
  end

  def invalid_api_key?
    !User.exists?(api_key: road_trip_params[:api_key])
  end
end