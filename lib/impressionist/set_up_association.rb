module Impressionist
  module SetUpAssociation

    def self.included(base)
      base.attr_accessible(:impressionable_type,:impressionable_id,
      :user_id,:controller_name,:action_name,:view_name,:request_hash,
      :ip_address,:session_hash,:message,:referrer)

      base.belongs_to(:impressionable, :polymorphic => true)
    end

  end

end
