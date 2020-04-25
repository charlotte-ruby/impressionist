class ProfilesController < ApplicationController
  helper_method :current_user

  def show
  end

  def current_user
    if session[:user_id]
      user = User.new
      user.id = session[:user_id]
      @current_user ||= user
    end
  end
end
