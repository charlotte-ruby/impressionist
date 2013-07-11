class Impression
  include Mongoid::Document
  include Mongoid::Timestamps

  include Impressionist::SetUpAssociation

  belongs_to :impressionable, polymorphic: true

  field :user_id
  field :controller_name
  field :action_name
  field :view_name
  field :request_hash
  field :ip_address
  field :session_hash
  field :message
  field :referrer

  set_callback(:create, :after) do |doc|
    unless impressionable_id.nil?
      impressionable_class = doc.impressionable_type.constantize

      if impressionable_class.impressionist_counter_cache_options
        resource = impressionable_class.find(doc.impressionable_id)
        resource.try(:update_impressionist_counter_cache)
      end
    end
  end
  
end
