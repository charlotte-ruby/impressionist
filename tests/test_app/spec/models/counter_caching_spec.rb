require 'spec_helper'

describe Impression do
  fixtures :widgets

  let(:widget) { Widget.find(1) }

  before(:each) do
    Impression.destroy_all
  end

  describe "self#impressionist_counter_caching?" do
    it "should know when counter caching is enabled" do
      expect(Widget).to be_impressionist_counter_caching
    end

    it "should know when counter caching is disabled" do
      expect(Article).not_to be_impressionist_counter_caching
    end
  end

  describe "self#counter_caching?" do
    it "should know when counter caching is enabled" do
      allow(ActiveSupport::Deprecation).to receive(:warn)
      expect(Widget).to be_counter_caching
    end

    it "should know when counter caching is disabled" do
      allow(ActiveSupport::Deprecation).to receive(:warn)
      expect(Article).not_to be_counter_caching
    end

  end

  describe "#update_impressionist_counter_cache" do
    it "should update the counter cache column to reflect the correct number of impressions" do
      expect {
         widget.impressions.create(:request_hash => 'abcd1234')
         widget.reload
       }.to change(widget, :impressions_count).from(0).to(1)
    end

    it "should not update the timestamp on the impressable" do
      expect {
         widget.impressions.create(:request_hash => 'abcd1234')
         widget.reload
       }.to_not change(widget, :updated_at)
    end
  end

end
