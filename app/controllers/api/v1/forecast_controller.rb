class Api::V1::ForecastController < ApplicationController
  def index
    if forecast_params[:location] == ''
      render_error('City and state is required.', 400)
    else
      forecast = ForecastFacade.new.get_forecast(forecast_params[:location])
      render json: ForecastSerializer.new(forecast)
    end
  end

  private

  def forecast_params
    params.permit(:location)
  end

  def render_error(message, status)
    render json: ErrorSerializer.new(ErrorMessage.new(message, status)).serialize_json, status: status
  end
end