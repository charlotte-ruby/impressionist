require 'spec_helper'

describe Impression do
  fixtures :widgets

  before(:each) do
    @widget = Widget.find(1)
  end

  context "when configured to use counter caching" do
    it "should know counter caching is enabled" do
      Widget.should be_counter_caching
    end
  end

  context "when not configured to use counter caching" do
    it "should know that counter caching is disabled" do
      Article.should_not be_counter_caching
    end
  end


end