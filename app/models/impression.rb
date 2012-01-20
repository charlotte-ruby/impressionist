class Impression < ActiveRecord::Base
  belongs_to :impressionable, :polymorphic=>true

  after_save :update_impressions_counter_cache

  private

  def update_impressions_counter_cache
    impressionable_class = self.impressionable_type.constantize

    if impressionable_class.counter_cache_options
      resouce = impressionable_class.find(self.impressionable_id)
      resouce.try(:update_counter_cache)
    end
  rescue NameError
    # If controller has no associated model, e.g. WelcomeController
  end
end