require 'spec_helper'

describe Impression do
  fixtures :articles,:impressions,:posts, :widgets

  describe "hstore support" do

    # Stub hstore methods for testing with sqlite
    before(:each){
      Impression.stub!(:hstore_enabled?).and_return(true)
      Impression.any_instance.stub(:params=> {"controller"=>"dummy", "action"=>"index"})
      Impression.stub_chain(:with).and_return(@impressions = [Impression.where(controller: 'widget')])
    }

    it "should respond true to hstore_enabled?" do
      Impression.hstore_enabled?.should be_true
    end

    describe "'with' scope" do

      it "should respond" do
        Impression.should respond_to(:with)
        Impression.should_receive(:with).and_return(Impression.with)
      end

      it "should respond with params key" do
        Impression.with("controller").should_not be_empty
      end

      it "should respond with params key and value" do
        Impression.with("controller", "widget").should_not be_empty
      end
    end

    describe "instance" do

      before(:each) do
        @article = Article.find(1)
      end

      it "should respond to 'param' and return params hash" do
        @article.impressions.create
        @article.impressions.last.should respond_to(:params)
        @article.impressions.last.params.should eq({"controller"=>"dummy", "action"=>"index"})
      end
    end
  end
end