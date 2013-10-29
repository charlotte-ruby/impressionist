require 'minitest_helper'
require 'impressionist/minion/minion_creator'

GranpaController = Class.new
Granpa = Class.new

module Impressionist
  describe Minion::MinionCreator do
    let(:granny)  { Minion::MinionCreator }
    let(:granpa) { GranpaController }

    before { granny.add(:granpa, :index) }

    it "must respond_to impressionable" do
      granpa.must_respond_to :impressionable
    end

    it "must have index action" do
      granpa.impressionable[:actions].first.must_equal :index
    end

    it "must have unique set to false" do
      granpa.impressionable[:unique].must_equal false
    end

    it "must have a Model" do
      granpa.impressionable[:class_name].must_equal ::Granpa
    end

    it "wont be counter_caching" do
      granpa.impressionable[:counter_cache].wont_equal true
    end

    it "must have total_impressions as default column_name" do
      granpa.impressionable[:column_name].must_equal :impressions_total
    end

    describe "Banana Potato" do

      let(:creator) { Impressionist::Minion::MinionCreator }
      it "must respond_to banana_potato" do
        creator.must_respond_to :banana_potato
      end

      it "must set self to MinionCreator" do
        creator.banana_potato do
          self.must_equal Impressionist::Minion::MinionCreator
        end
      end

    end
  end
end
