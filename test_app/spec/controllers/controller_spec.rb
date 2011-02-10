require 'spec_helper.rb'

describe ArticlesController do
  fixtures :articles,:impressions,:posts
  render_views
  
  it "should make the impressionable_hash available" do
    get "index"
    response.body.include?("false").should eq true
  end
  
  it "should log an impression with a message" do
    get "index"
    Impression.all.size.should eq 11
    Article.first.impressions.last.message.should eq "this is a test article impression"
  end
  
  it "should log an impression without a message" do
    get "show", id: 1
    Impression.all.size.should eq 11
    Article.first.impressions.last.message.should eq nil
  end
  
  it "should log the user_id if user is authenticated (@current_user before_filter method)" do
    session[:user_id] = 123
    get "show", id: 1
    Article.first.impressions.last.user_id.should eq 123
  end
  
  it "should not log the user_id if user is authenticated" do
    get "show", id: 1
    Article.first.impressions.last.user_id.should eq nil
  end
end  

describe PostsController do
  it "should log impression at the action level" do
    get "show", id: 1
    Impression.all.size.should eq 11
    Impression.last.controller_name.should eq "posts"
    Impression.last.impressionable_type.should eq "Post"
    Impression.last.impressionable_id.should eq 1
  end
  
  it "should log the user_id if user is authenticated (current_user helper method)" do
    session[:user_id] = 123
    get "show", id: 1
    Post.first.impressions.last.user_id.should eq 123
  end
end

describe WidgetsController do
  it "should log impression at the per action level" do
    get "show", id: 1
    Impression.all.size.should eq 11
    get "index"
    Impression.all.size.should eq 12
    get "new"
    Impression.all.size.should eq 12
  end
  
  it "should not log impression when user-agent is in wildcard list" do
    request.stub!(:user_agent).and_return('somebot')
    get "show", id: 1
    Impression.all.size.should eq 10
  end
  
  it "should not log impression when user-agent is in the bot list" do
    request.stub!(:user_agent).and_return('Acoon Robot v1.50.001')
    get "show", id: 1
    Impression.all.size.should eq 10    
  end
end
  