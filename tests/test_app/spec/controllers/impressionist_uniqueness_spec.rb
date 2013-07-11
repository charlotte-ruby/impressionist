require 'spec_helper'

# we use the posts controller as it uses the impressionsist module. any such controller would do.
describe DummyController do

  before do
    @impression_count = Impression.all.size
  end

  describe "impressionist filter uniqueness" do

    it "should ignore uniqueness if not requested" do
      controller.impressionist_subapp_filter(nil, nil)
      controller.impressionist_subapp_filter(nil, nil)
      Impression.should have(@impression_count + 2).records
    end

    it "should recognize unique session" do
      controller.stub!(:session_hash).and_return(request.session_options[:id])
      controller.impressionist_subapp_filter(nil, [:session_hash])
      controller.impressionist_subapp_filter(nil, [:session_hash])
      Impression.should have(@impression_count + 1).records
    end

    it "should recognize unique ip" do
      controller.request.stub!(:remote_ip).and_return("1.2.3.4")
      controller.impressionist_subapp_filter(nil, [:ip_address])
      controller.impressionist_subapp_filter(nil, [:ip_address])
      Impression.should have(@impression_count + 1).records
    end

    it "should recognize unique request" do
      controller.impressionist_subapp_filter(nil, [:request_hash])
      controller.impressionist_subapp_filter(nil, [:request_hash])
      Impression.should have(@impression_count + 1).records
    end

    it "should recognize unique action" do
      controller.stub!(:action_name).and_return("test_action")
      controller.impressionist_subapp_filter(nil, [:action_name])
      controller.impressionist_subapp_filter(nil, [:action_name])
      Impression.should have(@impression_count + 1).records
    end

    it "should recognize unique controller" do
      controller.stub!(:controller_name).and_return("post")
      controller.impressionist_subapp_filter(nil, [:controller_name])
      controller.impressionist_subapp_filter(nil, [:controller_name])
      Impression.should have(@impression_count + 1).records
    end

    it "should recognize unique user" do
      controller.stub!(:user_id).and_return(42)
      controller.impressionist_subapp_filter(nil, [:user_id])
      controller.impressionist_subapp_filter(nil, [:user_id])
      Impression.should have(@impression_count + 1).records
    end

    it "should recognize unique referer" do
      controller.request.stub!(:referer).and_return("http://foo/bar")
      controller.impressionist_subapp_filter(nil, [:referrer])
      controller.impressionist_subapp_filter(nil, [:referrer])
      Impression.should have(@impression_count + 1).records
    end

    it "should recognize unique id" do
      controller.stub!(:params).and_return({:id => "666"}) # for correct impressionable id in filter
      controller.impressionist_subapp_filter(nil, [:impressionable_id])
      controller.impressionist_subapp_filter(nil, [:impressionable_id])
      Impression.should have(@impression_count + 1).records
    end

    # extra redundant test for important controller and action combination.
    it "should recognize different controller and action" do
      controller.stub!(:controller_name).and_return("post")
      controller.stub!(:action_name).and_return("test_action")
      controller.impressionist_subapp_filter(nil, [:controller_name, :action_name])
      controller.impressionist_subapp_filter(nil, [:controller_name, :action_name])
      Impression.should have(@impression_count + 1).records
      controller.stub!(:action_name).and_return("another_action")
      controller.impressionist_subapp_filter(nil, [:controller_name, :action_name])
      controller.impressionist_subapp_filter(nil, [:controller_name, :action_name])
      Impression.should have(@impression_count + 2).records
      controller.stub!(:controller_name).and_return("article")
      controller.impressionist_subapp_filter(nil, [:controller_name, :action_name])
      controller.impressionist_subapp_filter(nil, [:controller_name, :action_name])
      Impression.should have(@impression_count + 3).records
    end

    it "should recognize different action" do
      controller.stub!(:action_name).and_return("test_action")
      controller.impressionist_subapp_filter(nil, [:action_name])
      controller.impressionist_subapp_filter(nil, [:action_name])
      Impression.should have(@impression_count + 1).records
      controller.stub!(:action_name).and_return("another_action")
      controller.impressionist_subapp_filter(nil, [:action_name])
      controller.impressionist_subapp_filter(nil, [:action_name])
      Impression.should have(@impression_count + 2).records
    end

    it "should recognize different controller" do
      controller.stub!(:controller_name).and_return("post")
      controller.impressionist_subapp_filter(nil, [:controller_name])
      controller.impressionist_subapp_filter(nil, [:controller_name])
      Impression.should have(@impression_count + 1).records
      controller.stub!(:controller_name).and_return("article")
      controller.impressionist_subapp_filter(nil, [:controller_name])
      controller.impressionist_subapp_filter(nil, [:controller_name])
      Impression.should have(@impression_count + 2).records
    end

    it "should recognize different session" do
      controller.stub!(:session_hash).and_return("foo")
      controller.impressionist_subapp_filter(nil, [:session_hash])
      controller.impressionist_subapp_filter(nil, [:session_hash])
      Impression.should have(@impression_count + 1).records
      controller.stub!(:session_hash).and_return("bar")
      controller.impressionist_subapp_filter(nil, [:session_hash])
      controller.impressionist_subapp_filter(nil, [:session_hash])
      Impression.should have(@impression_count + 2).records
    end

    it "should recognize different ip" do
      controller.request.stub!(:remote_ip).and_return("1.2.3.4")
      controller.impressionist_subapp_filter(nil, [:ip_address])
      controller.impressionist_subapp_filter(nil, [:ip_address])
      Impression.should have(@impression_count + 1).records
      controller.request.stub!(:remote_ip).and_return("5.6.7.8")
      controller.impressionist_subapp_filter(nil, [:ip_address])
      controller.impressionist_subapp_filter(nil, [:ip_address])
      Impression.should have(@impression_count + 2).records
    end

    it "should recognize different referer" do
      controller.request.stub!(:referer).and_return("http://foo/bar")
      controller.impressionist_subapp_filter(nil, [:referrer])
      controller.impressionist_subapp_filter(nil, [:referrer])
      Impression.should have(@impression_count + 1).records
      controller.request.stub!(:referer).and_return("http://bar/fo")
      controller.impressionist_subapp_filter(nil, [:referrer])
      controller.impressionist_subapp_filter(nil, [:referrer])
      Impression.should have(@impression_count + 2).records
    end

    it "should recognize different id" do
      controller.stub!(:params).and_return({:id => "666"}) # for correct impressionable id in filter
      controller.impressionist_subapp_filter(nil, [:impressionable_type, :impressionable_id])
      controller.impressionist_subapp_filter(nil, [:impressionable_type, :impressionable_id])
      controller.stub!(:params).and_return({:id => "42"}) # for correct impressionable id in filter
      controller.impressionist_subapp_filter(nil, [:impressionable_type, :impressionable_id])
      controller.impressionist_subapp_filter(nil, [:impressionable_type, :impressionable_id])
      Impression.should have(@impression_count + 2).records
    end

    it "should recognize combined uniqueness" do
      controller.stub!(:action_name).and_return("test_action")
      controller.impressionist_subapp_filter(nil, [:ip_address, :request_hash, :action_name])
      controller.impressionist_subapp_filter(nil, [:request_hash, :ip_address, :action_name])
      controller.impressionist_subapp_filter(nil, [:request_hash, :action_name])
      controller.impressionist_subapp_filter(nil, [:ip_address, :action_name])
      controller.impressionist_subapp_filter(nil, [:ip_address, :request_hash])
      controller.impressionist_subapp_filter(nil, [:action_name])
      controller.impressionist_subapp_filter(nil, [:ip_address])
      controller.impressionist_subapp_filter(nil, [:request_hash])
      Impression.should have(@impression_count + 1).records
    end

    it "should recognize combined non-uniqueness" do
      controller.stub!(:action_name).and_return(nil)
      controller.impressionist_subapp_filter(nil, [:ip_address, :action_name])
      controller.stub!(:action_name).and_return("test_action")
      controller.impressionist_subapp_filter(nil, [:ip_address, :action_name])
      controller.stub!(:action_name).and_return("another_action")
      controller.impressionist_subapp_filter(nil, [:ip_address, :action_name])
      Impression.should have(@impression_count + 3).records
    end

  end

  describe "impressionist method uniqueness for impressionables" do

    # in this test we reuse the post model. might break if model changes.

    it "should ignore uniqueness if not requested" do
      impressionable = Post.create
      controller.impressionist impressionable
      controller.impressionist impressionable
      Impression.should have(@impression_count + 2).records
    end

    it "should recognize unique session" do
      controller.stub!(:session_hash).and_return(request.session_options[:id])
      impressionable = Post.create
      controller.impressionist(impressionable, nil, :unique => [:session_hash])
      controller.impressionist(impressionable, nil, :unique => [:session_hash])
      Impression.should have(@impression_count + 1).records
    end

    it "should recognize unique ip" do
      controller.request.stub!(:remote_ip).and_return("1.2.3.4")
      impressionable = Post.create
      controller.impressionist(impressionable, nil, :unique => [:ip_address])
      controller.impressionist(impressionable, nil, :unique => [:ip_address])
      Impression.should have(@impression_count + 1).records
    end

    it "should recognize unique request" do
      impressionable = Post.create
      controller.impressionist(impressionable, nil, :unique => [:request_hash])
      controller.impressionist(impressionable, nil, :unique => [:request_hash])
      Impression.should have(@impression_count + 1).records
    end

    it "should recognize unique user" do
      controller.stub!(:user_id).and_return(666)
      impressionable = Post.create
      controller.impressionist(impressionable, nil, :unique => [:user_id])
      controller.impressionist(impressionable, nil, :unique => [:user_id])
      Impression.should have(@impression_count + 1).records
    end

    it "should recognize unique referer" do
      controller.request.stub!(:referer).and_return("http://foo/bar")
      impressionable = Post.create
      controller.impressionist(impressionable, nil, :unique => [:referrer])
      controller.impressionist(impressionable, nil, :unique => [:referrer])
      Impression.should have(@impression_count + 1).records
    end

    it "should recognize different session" do
      impressionable = Post.create
      controller.stub!(:session_hash).and_return("foo")
      controller.impressionist(impressionable, nil, :unique => [:session_hash])
      controller.impressionist(impressionable, nil, :unique => [:session_hash])
      Impression.should have(@impression_count + 1).records
      controller.stub!(:session_hash).and_return("bar")
      controller.impressionist(impressionable, nil, :unique => [:session_hash])
      controller.impressionist(impressionable, nil, :unique => [:session_hash])
      Impression.should have(@impression_count + 2).records
    end

    it "should recognize different ip" do
      controller.request.stub!(:remote_ip).and_return("1.2.3.4")
      impressionable = Post.create
      controller.impressionist(impressionable, nil, :unique => [:ip_address])
      controller.impressionist(impressionable, nil, :unique => [:ip_address])
      Impression.should have(@impression_count + 1).records
      controller.request.stub!(:remote_ip).and_return("5.6.7.8")
      controller.impressionist(impressionable, nil, :unique => [:ip_address])
      controller.impressionist(impressionable, nil, :unique => [:ip_address])
      Impression.should have(@impression_count + 2).records
    end

    it "should recognize different user" do
      impressionable = Post.create
      controller.stub!(:user_id).and_return(666)
      controller.impressionist(impressionable, nil, :unique => [:user_id])
      controller.impressionist(impressionable, nil, :unique => [:user_id])
      Impression.should have(@impression_count + 1).records
      controller.stub!(:user_id).and_return(42)
      controller.impressionist(impressionable, nil, :unique => [:user_id])
      controller.impressionist(impressionable, nil, :unique => [:user_id])
      Impression.should have(@impression_count + 2).records
    end

    it "should recognize combined uniqueness" do
      impressionable = Post.create
      controller.stub!(:session_hash).and_return("foo")
      controller.impressionist(impressionable, nil, :unique => [:ip_address, :request_hash, :session_hash])
      controller.impressionist(impressionable, nil, :unique => [:request_hash, :ip_address, :session_hash])
      controller.impressionist(impressionable, nil, :unique => [:request_hash, :session_hash])
      controller.impressionist(impressionable, nil, :unique => [:ip_address, :session_hash])
      controller.impressionist(impressionable, nil, :unique => [:ip_address, :request_hash])
      controller.impressionist(impressionable, nil, :unique => [:session_hash])
      controller.impressionist(impressionable, nil, :unique => [:ip_address])
      controller.impressionist(impressionable, nil, :unique => [:request_hash])
      Impression.should have(@impression_count + 1).records
    end

    it "should recognize combined non-uniqueness" do
      impressionable = Post.create
      controller.stub!(:session_hash).and_return(nil)
      controller.impressionist(impressionable, nil, :unique => [:ip_address, :session_hash])
      controller.stub!(:session_hash).and_return("foo")
      controller.impressionist(impressionable, nil, :unique => [:ip_address, :session_hash])
      controller.stub!(:session_hash).and_return("bar")
      controller.impressionist(impressionable, nil, :unique => [:ip_address, :session_hash])
      Impression.should have(@impression_count + 3).records
    end

  end

  describe "impressionist filter and method uniqueness" do

    it "should recognize uniqueness" do
      impressionable = Post.create
      controller.stub!(:controller_name).and_return("posts") # for correct impressionable type in filter
      controller.stub!(:params).and_return({:id => impressionable.id.to_s}) # for correct impressionable id in filter
      controller.stub!(:session_hash).and_return("foo")
      controller.request.stub!(:remote_ip).and_return("1.2.3.4")
      # order of the following methods is important for the test!
      controller.impressionist_subapp_filter(nil, [:ip_address, :request_hash, :session_hash])
      controller.impressionist(impressionable, nil, :unique => [:ip_address, :request_hash, :session_hash])
      Impression.should have(@impression_count + 1).records
    end

  end

end

