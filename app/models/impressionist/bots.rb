require "device_detector"

module Impressionist
  module Bots

    def self.bot?(user_agent = nil)
      return false if user_agent.nil?
      DeviceDetector.new(user_agent).bot?
    end

  end
end
