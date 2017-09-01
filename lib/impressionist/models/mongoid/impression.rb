##
# see active_record/impression.rb
# same doc applies to here
class Impression
  include Mongoid::Document
  include Mongoid::Timestamps

  include Impressionist::CounterCache
  Impressionist::SetupAssociation.new(self).set

  field :impressionable_id, type: BSON::ObjectId
  field :impressionable_type
  field :user_id
  field :controller_name
  field :action_name
  field :view_name
  field :request_hash
  field :ip_address
  field :session_hash
  field :message
  field :referrer
  field :params

  after_save :impressionable_counter_cache_updatable?

end
