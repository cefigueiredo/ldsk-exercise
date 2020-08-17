class Api::V1::UsersController < ApplicationController
  prepend_before_action :authenticate!

  def create
    user = User.new(user_params)

    if user.persisted?
      render json: { error: "User already exists" }, status: 400 and return
    elsif user.save
      render json: user, status: 200 and return
    end

    render json: { error: "It was not possible to create the user: #{user.errors.messages}" }, status: 400
  end

  def index
    render json: User.map(params["cursor"]), status: 200
  end

  def show
    user = User.find_by_username params[:username]

    if user
      render json: user, status: 200 and return
    end

    render json: { error: "User not found" }, status: 404
  end

  def update
    user = User.new(user_params)

    unless user.exists?
      render json: { error: "User does not exist" }, status: 404 and return
    end

    unless user.save?
      render json: { error: "It was not possible to update the user: #{user.errros.messages}" }, status: 400 and return
    end

    render json: user, status: 200
  end

  def destroy
    user = User.find_by_username(params[:username])

    unless user.exists?
      render json: { error: "User not found" }, status: 404 and return
    end

    unless user.delete
      render json: { error: "An error occurred and user was not deleted." }, status: 400 and return
    end

    render json: { message: "User successfuly deleted" }, status: 200
  end

  private

  def user_params
    params.permit(:username, :name, :password, :email)
  end
end
