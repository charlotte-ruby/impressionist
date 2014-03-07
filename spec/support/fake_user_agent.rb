class FakeUserAgentChecker
  def self.valid?(user_agent)
    user_agent == :valid ? true : false
  end
end

module Impressionist
  UserAgentChecker ||= ::FakeUserAgentChecker
end
