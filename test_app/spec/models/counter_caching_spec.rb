require 'spec_helper'

describe Impression do
  fixtures :widgets

  before(:each) do
    @widget = Widget.find(1)
    Impression.destroy_all
  end

  describe "self#counter_caching?" do
    it "should know when counter caching is enabled" do
      Widget.should be_counter_caching
    end

    it "should know when counter caching is disabled" do
      Article.should_not be_counter_caching
    end
  end

  describe "#update_counter_cache" do
    it "should update the counter cache column to reflect the correct number of impressions" do
      lambda {
         Impression.create(:impressionable_type => @widget.class.name, :impressionable_id => @widget.id)
         @widget.reload
       }.should change(@widget, :impressions_count).from(0).to(1)
    end
  end

end
