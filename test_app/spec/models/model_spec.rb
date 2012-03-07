require 'spec_helper'

describe Impression do
  fixtures :articles,:impressions,:posts

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

  # tests :dependent => :destroy
  it "should delete impressions on deletion of impressionable" do
    impressions_count = Impression.all.size
    a = Article.create
    i = a.impressions.create
    a.destroy
    a.destroyed?.should be_true
    i.destroyed?.should be_true
  end

  #OLD COUNT METHODS.  DEPRECATE SOON
  it "should return the impression count with no date range specified" do
    @article.impression_count.should eq 11
  end

  it "should return unique impression count with no date range specified" do
    @article.unique_impression_count.should eq 9
  end

  it "should return impression count with only start date specified" do
    @article.impression_count("2011-01-01").should eq 8
  end

  it "should return impression count with whole date range specified" do
    @article.impression_count("2011-01-01","2011-01-02").should eq 7
  end

  it "should return unique impression count with only start date specified" do
    @article.unique_impression_count("2011-01-01").should eq 7
  end

  it "should return unique impression count with date range specified" do
    @article.unique_impression_count("2011-01-01","2011-01-02").should eq 7
  end

  it "should return unique impression count using ip address (which in turn eliminates duplicate request_hashes)" do
    @article.unique_impression_count_ip.should eq 8
  end

  it "should return unique impression count using session_hash (which in turn eliminates duplicate request_hashes)" do
    @article.unique_impression_count_session.should eq 7
  end
end
