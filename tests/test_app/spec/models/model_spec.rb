require 'spec_helper'

describe Impression do
  fixtures :articles,:impressions,:posts,:profiles

  before(:each) do
    @article = Article.find(1)
  end

  it "should save a blank impression for an Article that has 10 impressions" do
    @article.impressions.create
    @article.impressions.size.should eq 12
  end

  it "should save an impression with a message" do
    @article.impressions.create(:message=>"test message")
    @article.impressions.last.message.should eq "test message"
  end

  it "should return the impression count for the message specified" do
    @article.impressions.create(:message => "pageview")
    @article.impressions.create(:message => "pageview")
    @article.impressions.create(:message => "visit")

    @article.impressionist_count(:message => "pageview", :filter => :all).should eq 2
  end

  it "should return the impression count for all with no date range specified" do
    @article.impressionist_count(:filter=>:all).should eq 11
  end

  it "should return unique impression count with no date range specified" do
    @article.impressionist_count.should eq 9
  end

  it "should return impression count with only start date specified" do
    @article.impressionist_count(:start_date=>"2011-01-01",:filter=>:all).should eq 8
  end

  it "should return impression count with whole date range specified" do
    @article.impressionist_count(:start_date=>"2011-01-01",:end_date=>"2011-01-02",:filter=>:all).should eq 7
  end

  it "should return unique impression count with only start date specified" do
    @article.impressionist_count(:start_date=>"2011-01-01").should eq 7
  end

  it "should return unique impression count with date range specified" do
    @article.impressionist_count(:start_date=>"2011-01-01",:end_date=>"2011-01-02").should eq 7
  end

  it "should return unique impression count using ip address (which in turn eliminates duplicate request_hashes)" do
    @article.impressionist_count(:filter=>:ip_address).should eq 8
  end

  it "should return unique impression count using session_hash (which in turn eliminates duplicate request_hashes)" do
    @article.impressionist_count(:filter=>:session_hash).should eq 7
  end

  # tests :dependent => :delete_all
  it "should delete impressions on deletion of impressionable" do
    #impressions_count = Impression.all.size
    a = Article.create
    i = a.impressions.create
    a.destroy
    a.destroyed?.should be_true
    Impression.exists?(i.id).should be_false
  end

end
