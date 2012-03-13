class Impression < ActiveRecord::Base
  belongs_to :impressionable, :polymorphic=>true
  belongs_to :user

  after_save :update_impressions_counter_cache

  attr_accessible :impressionable_type, :impressionable_id, :user_id,
  :controller_name, :action_name, :view_name, :request_hash, :ip_address,
  :session_hash, :message, :referrer

  private

  def update_impressions_counter_cache
    impressionable_class = self.impressionable_type.constantize

    if impressionable_class.counter_cache_options
      resouce = impressionable_class.find(self.impressionable_id)
      resouce.try(:update_counter_cache)
    end
  end
end
