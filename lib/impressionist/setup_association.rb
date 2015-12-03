module Impressionist
  # Impressionist::SetupAssociation.new(entity).set
  class SetupAssociation
    def initialize(receiver)
      @receiver = receiver
    end

    # True or False
    # Note toggle returns false if rails >= 4
    def include_attr_acc?
      toggle && make_accessible
    end

    def define_belongs_to
      receiver.belongs_to(:impressionable, polymorphic: true)
    end

    def set
      define_belongs_to
      include_attr_acc?
    end

    private

    attr_reader :receiver, :toggle

    def make_accessible
      receiver
        .attr_accessible(:impressionable_type,
                         :impressionable_id,
                         :controller_name,
                         :request_hash,
                         :session_hash,
                         :action_name,
                         :ip_address,
                         :view_name,
                         :referrer,
                         :user_agent,
                         :message,
                         :user_id,
                         :params)
    end

    def toggle
      t = RailsToggle.new
      t.should_include?
    end
  end
end
