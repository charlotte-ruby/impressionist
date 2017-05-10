class ApplicationController < ActionController::Base
  protect_from_forgery
  if Rails::VERSION::MAJOR >= 5
    before_action :secondary_before_action
  else
    before_filter :secondary_before_action
  end

  def secondary_before_action
    @test_secondary_before_action = "this is a test"
  end
end
