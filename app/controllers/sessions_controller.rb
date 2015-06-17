class SessionsController < ApplicationController
  before_action :require_user, only: [:destroy]

  def new
    redirect_to home_path if logged_in?
  end

  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      redirect_to home_path, notice: "You are signed in!"
    else
      flash[:alert] = "Invalid email or password."
      redirect_to sign_in_path
    end

  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "You are signed out."
  end

end