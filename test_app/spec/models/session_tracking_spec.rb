require 'spec_helper'

describe Impression do
  fixtures :impressions

  before(:each) do
    @imp = Impression.first
  end

  describe "self#next" do
    it "should return impressions of the same session" do
      @imp.next.collect(&:session_hash).uniq.count.should equal 1
    end

    it "should return impressions of the same session as the receiver" do
      @imp.next.collect(&:session_hash).uniq.first.should equal imp.session_hash
    end

    it "should return impressions after the receiver" do
      @imp.next.collect(&:created_at).reduce(true){|after,date| after && @imp.created_at < date}
    end
  end

end
