class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :secondary_before_filter

  def secondary_before_filter
    @test_secondary_before_filter = "this is a test"
  end
end
