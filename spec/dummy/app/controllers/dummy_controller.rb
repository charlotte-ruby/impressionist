# This controller imports the impressionist module to make the modules methods available for testing
class DummyController < ApplicationController
  impressionist

  def index; end
end
