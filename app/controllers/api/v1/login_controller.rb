class Api::V1::LoginController < ApplicationController
  def create
    @user = User.find_by_username(params[:username])

    unless @user
      render json: { error: "User not found" }, status: 404 and return
    end

    unless @user.authenticate(params[:password])
      render json: { error: "Incorrect password" }, status: 401 and return
    end

    render json: session_token, status: 200
  end

  private

  def session_token
    @session ||= Session.create_token(@user.username)
  end
end
