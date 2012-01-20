class WelcomeController < ApplicationController
  impressionist :action_name => Proc.new{|c| c.params[:page]}

  def static
    #render params[:page]
  end
end