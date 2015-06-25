require 'spec_helper'

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

  it "should log impression at the action level with params" do
    get "show", id: 1, checked: true
    Impression.all.size.should eq 12
    Impression.last.params.should eq({"checked"=>true})
    Impression.last.controller_name.should eq "posts"
    Impression.last.action_name.should eq "show"
    Impression.last.impressionable_type.should eq "Post"
    Impression.last.impressionable_id.should eq 1
  end
end
