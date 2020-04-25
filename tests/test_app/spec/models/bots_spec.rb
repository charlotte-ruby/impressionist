require 'spec_helper'

describe Impressionist::Bots do

  describe "self.bot?" do
    it "is true if user_agent is matches wild card" do
      expect(Impressionist::Bots.bot?("google.com bot")).to be_truthy
    end

    it "is true if user_agent is on bot list" do
      expect(Impressionist::Bots.bot?("A-Online Search")).to be_truthy
    end

    it "is false if user_agent is blank" do
      expect(Impressionist::Bots.bot?("")).to be_falsey
      expect(Impressionist::Bots.bot?(nil)).to be_falsey
    end

    it "is false if user_agent is safe" do
      expect(Impressionist::Bots.bot?('127.0.0.1')).to be_falsey
    end

    it "is false if user_agent not given" do
      expect(Impressionist::Bots.bot?).to be_falsey
    end
  end
end