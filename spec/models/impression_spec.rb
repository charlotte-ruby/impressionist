require 'spec_helper'

describe Impression do
  fixtures :articles, :impressions, :posts, :profiles

  let(:article) { Article.find(1) }

  it "saves a blank impression for an Article that has 10 impressions" do
    article.impressions.create
    expect(article.impressions.size).to eq 12
  end

  it "saves an impression with a message" do
    article.impressions.create(:message => "test message")
    expect(article.impressions.last.message).to eq "test message"
  end

  it "returns the impression count for the message specified" do
    article.impressions.create(:message => "pageview")
    article.impressions.create(:message => "pageview")
    article.impressions.create(:message => "visit")

    expect(article.impressionist_count(:message => "pageview", :filter => :all)).to eq 2
  end

  it "returns the impression count for all with no date range specified" do
    expect(article.impressionist_count(:filter => :all)).to eq 11
  end

  it "returns unique impression count with no date range specified" do
    expect(article.impressionist_count).to eq 9
  end

  it "returns impression count with only start date specified" do
    expect(article.impressionist_count(:start_date => "2011-01-01", :filter => :all)).to eq 8
  end

  it "returns impression count with whole date range specified" do
    expect(article.impressionist_count(:start_date => "2011-01-01", :end_date => "2011-01-02", :filter => :all)).to eq 7
  end

  it "returns unique impression count with only start date specified" do
    expect(article.impressionist_count(:start_date => "2011-01-01")).to eq 7
  end

  it "returns unique impression count with date range specified" do
    expect(article.impressionist_count(:start_date => "2011-01-01", :end_date => "2011-01-02")).to eq 7
  end

  it "returns unique impression count using ip address (which in turn eliminates duplicate request_hashes)" do
    expect(article.impressionist_count(:filter => :ip_address)).to eq 8
  end

  it "returns unique impression count using session_hash (which in turn eliminates duplicate request_hashes)" do
    expect(article.impressionist_count(:filter => :session_hash)).to eq 7
  end

  it "deletes impressions on deletion of impressionable" do
    article = Article.create
    impression = article.impressions.create
    article.destroy

    expect(article).to be_destroyed
    expect(described_class).not_to exist(impression.id)
  end
end
