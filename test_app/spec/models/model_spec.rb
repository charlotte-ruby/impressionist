require 'spec_helper'

describe Impression do
  fixtures :articles,:impressions
  
  before(:each) do
    @article = Article.find(1)
  end
  
  it "should save a blank impression for an Article that has 10 impressions" do
    @article.impressions.create
    @article.impressions.size.should eq 11
  end
  
  it "should save an impression with a message" do
    @article.impressions.create(message:"test message")
    @article.impressions.last.message.should eq "test message"
  end
  
  it "should return the view count with no date range specified" do
    @article.impression_count.should eq 10
  end
  
  it "should return unique view count with no date range specified" do
    @article.unique_impression_count.should eq 7
  end
  
  it "should return view count with only start date specified" do
    @article.impression_count("2011-01-01").should eq 8
  end
  
  it "should return view count with whole date range specified" do
    @article.impression_count("2011-01-01","2011-01-02").should eq 7
  end

  it "should return unique view count with only start date specified" do
    @article.unique_impression_count("2011-01-01").should eq 7
  end
  
  it "should return unique view count with date range specified" do
    @article.unique_impression_count("2011-01-01","2011-01-02").should eq 7
  end
end