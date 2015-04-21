require 'spec_helper'

describe WidgetsController do

  before(:each) do
    @widget = Widget.find(1)
    Widget.stub(:find).and_return(@widget)
  end

  it "should log impression at the per action level" do
    get "show", :id=> 1
    Impression.all.size.should eq 12
    get "index"
    Impression.all.size.should eq 13
    get "new"
    Impression.all.size.should eq 13
  end

  it "should not log impression when user-agent is in wildcard list" do
    request.stub(:user_agent).and_return('somebot')
    get "show", :id=> 1
    Impression.all.size.should eq 11
  end

  it "should not log impression when user-agent is in the bot list" do
    request.stub(:user_agent).and_return('Acoon Robot v1.50.001')
    get "show", :id=> 1
    Impression.all.size.should eq 11
  end

  context "impressionist unique options" do

    it "should log unique impressions at the per action level" do
      get "show", :id=> 1
      Impression.all.size.should eq 12
      get "show", :id=> 2
      Impression.all.size.should eq 13
      get "show", :id => 2
      Impression.all.size.should eq 13
      get "index"
      Impression.all.size.should eq 14
    end

    it "should log unique impressions only once per id" do
      get "show", :id=> 1
      Impression.all.size.should eq 12
      get "show", :id=> 2
      Impression.all.size.should eq 13

      get "show", :id => 2
      Impression.all.size.should eq 13

      get "index"
      Impression.all.size.should eq 14
    end

  end

  context "Impresionist unique params options" do
    it "should log unique impressions at the per action and params level" do
      get "show", :id => 1
      Impression.all.size.should eq 12
      get "show", :id => 2, checked: true
      Impression.all.size.should eq 13	
      get "show", :id => 2, checked: false
      Impression.all.size.should eq 14
      get "index"
      Impression.all.size.should eq 15
    end

    it "should not log impression for same params and same id" do
      get "show", :id => 1
      Impression.all.size.should eq 12
      get "show", :id => 1
      Impression.all.size.should eq 12
      get "show", :id => 1, checked: true
      Impression.all.size.should eq 13	
      get "show", :id => 1, checked: false
      Impression.all.size.should eq 14
      get "show", :id => 1, checked: true
      Impression.all.size.should eq 14
      get "show", :id => 1, checked: false
      Impression.all.size.should eq 14
      get "show", :id => 1
      Impression.all.size.should eq 14
      get "show", :id => 2
      Impression.all.size.should eq 15
    end
  end

end
