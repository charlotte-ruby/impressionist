require 'minitest_helper'
require 'impressionist/minion/minion_creator'

FakeController  = Class.new
Fake            = Class.new

module Impressionist
  describe Minion::MinionCreator do
    let(:creator)  { Minion::MinionCreator }
    let(:controller) { FakeController }

    before { creator.add(:fake, :index) }

    it "must respond_to impressionable" do
      controller.must_respond_to :impressionable
    end

    it "must have index action" do
      controller.impressionable[:actions].first.must_equal :index
    end

    it "must have unique set to false" do
      controller.impressionable[:unique].must_equal false
    end

    it "must have a Model" do
      controller.impressionable[:class_name].must_equal ::Fake
    end

    it "wont be counter_caching" do
      controller.impressionable[:counter_cache].wont_equal true
    end

    it "must have total_impressions as default column_name" do
      controller.impressionable[:column_name].must_equal :impressions_total
    end

    describe "Banana Potato" do

      let(:mcreator) { Impressionist::Minion::MinionCreator }
      it "must respond_to banana_potato" do
        mcreator.must_respond_to :banana_potato
      end

      it "must set self to MinionCreator" do
        mcreator.banana_potato do
          self.must_equal Impressionist::Minion::MinionCreator
        end
      end

    end
  end
end
