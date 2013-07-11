module Impressionist
  module SetUpAssociation

    def self.included(base)
      # include attr_accessible base on
      # rails version
      should_include?
      base.
      belongs_to(:impressionable,:polymorphic => true)
    end

private

    def self.should_include?
      toggle = Impressionist::RailsToggle.new(Rails::VERSION::MAJOR)
      self.include_attr_accessible unless toggle.valid?
    end

    def self.include_attr_accessible
      base.attr_accessible(:impressionable_type,:impressionable_id,
      :user_id,:controller_name,:action_name,:view_name,:request_hash,
      :ip_address,:session_hash,:message,:referrer)

    end

  end

end
