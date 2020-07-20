require 'spec_helper'

describe PostsController do
  it "logs impression at the action level" do
    get :show, params: { id: 1 }

    expect(Impression.all.size).to eq 12

    impression = Impression.last

    expect(impression.controller_name).to eq "posts"
    expect(impression.action_name).to eq "show"
    expect(impression.impressionable_type).to eq "Post"
    expect(impression.impressionable_id).to eq 1
  end

  it "logs the user_id if user is authenticated (current_user helper method)" do
    session[:user_id] = 123
    get :show, params: { id: 1 }
    expect(Post.first.impressions.last.user_id).to eq 123
  end

  it "logs impression at the action level with params" do
    get :show, params: { id: 1, checked: true }

    expect(Impression.all.size).to eq 12

    impression = Impression.last

    expect(impression.params).to eq({ "checked" => "true" })
    expect(impression.controller_name).to eq "posts"
    expect(impression.action_name).to eq "show"
    expect(impression.impressionable_type).to eq "Post"
    expect(impression.impressionable_id).to eq 1
  end
end
