class WidgetsController < ApplicationController
  impressionist :actions=>[:show,:index], :unique => [:controller_name,:action_name,:impressionable_id]

  def show
  end

  def index
  end

  def new
  end
end
