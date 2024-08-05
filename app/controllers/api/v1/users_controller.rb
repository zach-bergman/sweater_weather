class Api::V1::UsersController < ApplicationController
  def create
    user = User.create(user_params)
    if user.save
      render json: UsersSerializer.new(user), status: :created
    else
      render json: ErrorSerializer.new(ErrorMessage.new(user.errors.full_messages.to_sentence, 400)).serialize_json, status: :bad_request
    end
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation)
  end
end