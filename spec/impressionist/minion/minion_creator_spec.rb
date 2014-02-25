require 'spec_helper'
require 'impressionist/minion/minion_creator'

FakeController  = Class.new
Fake            = Class.new

module Impressionist
  describe Minion::MinionCreator do
    let(:creator)  { Minion::MinionCreator }
    let(:controller) { FakeController }

    before { creator.add(:fake, :index) }

    it "must have index action" do
      controller.impressionable[:actions].first.should eq :index
    end

    it "must have unique set to false" do
      controller.impressionable[:unique].should eq false
    end

    it "must have a Model" do
      controller.impressionable[:class_name].should eq ::Fake
    end

    it "wont be counter_caching" do
      controller.impressionable[:counter_cache].should be_false
    end

    it "must have default column_name" do
      controller.impressionable[:column_name].should eq :impressions_total
    end

    it "must have default hook" do
      controller.impressionable[:hook].should eq "before"
    end

    describe "Banana Potato" do

      let(:mcreator) { Impressionist::Minion::MinionCreator }

      it "must set self to MinionCreator" do
        mcreator.banana_potato do
          self.should == Impressionist::Minion::MinionCreator
        end
      end

    end
  end
end
