class Impression < ActiveRecord::Base
  attr_accessible :impressionable_type, :impressionable_id, :user_id,
  :controller_name, :action_name, :view_name, :request_hash, :ip_address,
  :session_hash, :message, :referrer, :params
  def self.hstore_enabled?
    !!(ActiveRecord::Base.connection.table_exists?(:impressions) && ActiveRecord::Base.connection.column_exists?(:impressions, :params, :hstore))
  end

  serialize :params, ActiveRecord::Coders::Hstore if self.hstore_enabled?
  attr_accessor :params unless self.hstore_enabled?

  scope :with, lambda {|key, value=nil|
    where("params"+(value.nil? ? " ? '"+key+"'" : " @> '"+key+" => "+value+"'")) if self.hstore_enabled?
  }

  belongs_to :impressionable, :polymorphic=>true

  after_save :update_impressions_counter_cache

  private

  def update_impressions_counter_cache
    if self.impressionable_type && self.impressionable_id
      impressionable_class = self.impressionable_type.constantize
      if impressionable_class.impressionist_counter_cache_options
        resouce = impressionable_class.find(self.impressionable_id)
        resouce.try(:update_impressionist_counter_cache)
      end
    end
  end
end
