require 'spec_helper'

require './app/models/impressionist/bots'

describe Impressionist::Bots do
  describe "bot detection" do
    it "matches wild card" do
      expect(described_class).to be_bot("google.com bot")
    end

    it "matches a bot list" do
      expect(described_class).to be_bot("A-Online Search")
    end

    it "skips blank user agents" do
      expect(described_class).not_to be_bot
      expect(described_class).not_to be_bot("")
      expect(described_class).not_to be_bot(nil)
    end

    it "skips safe matches" do
      expect(described_class).not_to be_bot('127.0.0.1')
    end
  end
end
