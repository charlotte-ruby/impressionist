require 'spec_helper'

describe ArticlesController do
  fixtures :articles,:impressions,:posts,:widgets
  render_views

  it "should make the impressionable_hash available" do
    get "index"
    response.body.include?("false").should eq true
  end

  it "should log an impression with a message" do
    get "index"
    Impression.all.size.should eq 12
    Article.first.impressions.last.message.should eq "this is a test article impression"
    Article.first.impressions.last.controller_name.should eq "articles"
    Article.first.impressions.last.action_name.should eq "index"
  end

  it "should log an impression without a message" do
    get "show", :id=> 1
    Impression.all.size.should eq 12
    Article.first.impressions.last.message.should eq nil
    Article.first.impressions.last.controller_name.should eq "articles"
    Article.first.impressions.last.action_name.should eq "show"
  end

  it "should log the user_id if user is authenticated (@current_user before_filter method)" do
    session[:user_id] = 123
    get "show", :id=> 1
    Article.first.impressions.last.user_id.should eq 123
  end

  it "should not log the user_id if user is authenticated" do
    get "show", :id=> 1
    Article.first.impressions.last.user_id.should eq nil
  end

  it "should log the request_hash, ip_address, referrer and session_hash" do
    get "show", :id=> 1
    Impression.last.request_hash.size.should eq 64
    Impression.last.ip_address.should eq "0.0.0.0"
    Impression.last.session_hash.size.should eq 32
    Impression.last.referrer.should eq nil
  end

  it "should log the referrer when you click a link" do
    visit article_url(Article.first)
    click_link "Same Page"
    Impression.last.referrer.should eq "http://test.host/articles/1"
  end
end

describe PostsController do
  it "should log impression at the action level" do
    get "show", :id=> 1
    Impression.all.size.should eq 12
    Impression.last.controller_name.should eq "posts"
    Impression.last.action_name.should eq "show"
    Impression.last.impressionable_type.should eq "Post"
    Impression.last.impressionable_id.should eq 1
  end

  it "should log the user_id if user is authenticated (current_user helper method)" do
    session[:user_id] = 123
    get "show", :id=> 1
    Post.first.impressions.last.user_id.should eq 123
  end
end

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
    request.stub!(:user_agent).and_return('somebot')
    get "show", :id=> 1
    Impression.all.size.should eq 11
  end

  it "should not log impression when user-agent is in the bot list" do
    request.stub!(:user_agent).and_return('Acoon Robot v1.50.001')
    get "show", :id=> 1
    Impression.all.size.should eq 11
  end

  describe "impressionist unique options" do

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

end
