require 'spec_helper'
require 'impressionist/user_agent_checker'

describe Impressionist::UserAgentChecker do
  let!(:user_agent_checker) { Impressionist::UserAgentChecker }
  describe "Checking validity" do
    context "Is a bot, crawler" do
      it "returns false" do
        result = user_agent_checker.valid?("Googlebot/2.1 (+http://www.googlebot.com/bot.html)")
        result.should be_false
      end
    end

    context "Is not a bot, crawler" do
      it "returns true" do
        result = user_agent_checker.
          valid?("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/32.0.1664.3 Safari/537.36")
        result.should be_true
      end
    end
  end
end
