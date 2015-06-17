class PagesController < ApplicationController
  before_filter :disable_nav
  def front
    redirect_to home_path if current_user
  end
end