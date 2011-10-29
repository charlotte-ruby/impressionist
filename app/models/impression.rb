class Impression < ActiveRecord::Base
  belongs_to :impressionable, :polymorphic=>true

  after_save :update_impressions_counter_cache

  private

  def update_impressions_counter_cache
    resouce = self.impressionable_type.constantize.find(self.impressionable_id)
    resouce.update_counter_cache if resouce.try(:cache_impression_count?)
  end
end