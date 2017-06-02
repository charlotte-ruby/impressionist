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

  it "should log the user_id if user is authenticated (@current_user before_action method)" do
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

  # Capybara has change the way it works
  # We need to pass :type options in order to make include helper methods
  # see https://github.com/jnicklas/capybara#using-capybara-with-rspec
  it "should log the referrer when you click a link", :type => :feature do
    visit article_url(Article.first)
    click_link "Same Page"
    Impression.last.referrer.should eq "http://test.host/articles/1"
  end

  it "should log request with params (checked = true)" do
    get "show", id: 1, checked: true
    Impression.last.params.should eq({"checked"=>true})
    Impression.last.request_hash.size.should eq 64
    Impression.last.ip_address.should eq "0.0.0.0"
    Impression.last.session_hash.size.should eq 32
    Impression.last.referrer.should eq nil
  end

  it "should log request with params {}" do
    get "index"
    Impression.last.params.should eq({})
    Impression.last.request_hash.size.should eq 64
    Impression.last.ip_address.should eq "0.0.0.0"
    Impression.last.session_hash.size.should eq 32
    Impression.last.referrer.should eq nil
  end

  describe "when filtering params" do
    before do
      @_filtered_params = Rails.application.config.filter_parameters
      Rails.application.config.filter_parameters = [:password]
    end

    it "values should not be recorded" do
      get "index", password: "best-password-ever"
      Impression.last.params.should eq("password" => "[FILTERED]")
    end

    after do
      Rails.application.config.filter_parameters = @_filtered_params
    end
  end
end
