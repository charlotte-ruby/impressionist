class ImpressionistJob < ApplicationJob
  queue_as :default

  def perform(obj, impression_params)
    obj.impressions.create(impression_params)
  end
end
