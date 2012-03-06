class ArticlesController < ApplicationController
  before_filter :test_current_user_var

  def test_current_user_var
    if session[:user_id]
      @current_user = User.new
      @current_user.id = session[:user_id]
    end
  end

  def index
    impressionist(Article.first,"this is a test article impression")
  end

  def show
    impressionist(Article.first)
  end
end
