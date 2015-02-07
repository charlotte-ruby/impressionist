class ProfilesController < ApplicationController
  helper_method :current_user

  def show
    @profile = Profile.friendly.find params[:id]
    impressionist(@profile, nil, :unique => [:impressionable_type, :impressionable_id])
  end

  def current_user
    if session[:user_id]
      user = User.new
      user.id = session[:user_id]
      @current_user ||= user
    end
  end
end
