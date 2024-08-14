class ImpressionistSubappJob < ApplicationJob
  queue_as :default

  def perform(impression_params)
    Impression.create(impression_params)
  end
end
