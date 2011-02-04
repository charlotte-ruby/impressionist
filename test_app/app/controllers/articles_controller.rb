class ArticlesController < ApplicationController
  def index
    impressionist(Article.first,"this is a test article impression")
  end
  
  def show
    impressionist(Article.first)
  end
end