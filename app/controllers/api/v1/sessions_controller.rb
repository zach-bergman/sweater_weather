class Api::V1::SessionsController < ApplicationController
  def create
    user = User.find_by(email: session_params[:email])
    if user && user.authenticate(session_params[:password])
      # session cookie?
      render json: UsersSerializer.new(user), status: :ok
    else
      render json: ErrorSerializer.new(ErrorMessage.new("Invalid credentials", 401)).serialize_json, status: 401
    end
  end

  private

  def session_params
    params.permit(:email, :password)
  end
end