class ApplicationController < ActionController::Base
  protect_from_forgery
  before_action :secondary_before_action

  def secondary_before_action
    @test_secondary_before_action = "this is a test"
  end
end
