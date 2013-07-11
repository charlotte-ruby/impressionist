require 'spec_helper'

describe Impressionist::Bots do

  describe "self.bot?" do
    it "is true if user_agent is matches wild card" do
      Impressionist::Bots.bot?("google.com bot").should be_true
    end

    it "is true if user_agent is on bot list" do
      Impressionist::Bots.bot?("A-Online Search").should be_true
    end

    it "is false if user_agent is blank" do
      Impressionist::Bots.bot?("").should be_false
      Impressionist::Bots.bot?(nil).should be_false
    end

    it "is false if user_agent is safe" do
      Impressionist::Bots.bot?('127.0.0.1').should be_false
    end

    it "is false if user_agent not given" do
      Impressionist::Bots.bot?.should be_false
    end
  end
end