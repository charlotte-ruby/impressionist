require 'spec_helper'

describe DummyController do
  fixtures :impressions
  render_views

  it "should log impression at the per action level on non-restful controller" do
    get "index"
    Impression.all.size.should eq 12
  end
end
