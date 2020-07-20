require 'spec_helper'

describe Impressionist::Bots do
  describe "self.bot?" do
    it "is true if user_agent is matches wild card" do
      expect(described_class).to be_bot("google.com bot")
    end

    it "is true if user_agent is on bot list" do
      expect(described_class).to be_bot("A-Online Search")
    end

    it "is false if user_agent is blank" do
      expect(described_class).not_to be_bot("")
      expect(described_class).not_to be_bot(nil)
    end

    it "is false if user_agent is safe" do
      expect(described_class).not_to be_bot('127.0.0.1')
    end

    it "is false if user_agent not given" do
      expect(described_class).not_to be_bot
    end
  end
end
