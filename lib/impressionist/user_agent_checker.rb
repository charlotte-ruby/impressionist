require 'agent_orange'

module Impressionist
  class UserAgentChecker

    def self.device; AgentOrange::UserAgent; end
    
    def self.valid?(user_agent)
      !( device.new(user_agent).is_bot? )
    end

  end
end
