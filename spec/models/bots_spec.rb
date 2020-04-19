require 'spec_helper'

require './app/models/impressionist/bots'

describe Impressionist::Bots do
  describe "bot detection" do
    it "matches wild card" do
      expect(described_class.bot?("google.com bot")).to be_truthy
    end

    it "matches a bot list" do
      expect(described_class.bot?("A-Online Search")).to be_truthy
    end

    it "skips blank user agents" do
      expect(described_class.bot?).to be_falsey
      expect(described_class.bot?("")).to be_falsey
      expect(described_class.bot?(nil)).to be_falsey
    end

    it "skips safe matches" do
      expect(described_class.bot?('127.0.0.1')).to be_falsey
    end
  end
end
