# This controller imports the impressionist module to make the modules methods available for testing
class DummyController < ActionController::Base

  impressionist

  def index
  end
end
