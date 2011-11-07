require 'spec_helper.rb'

# we use the posts controller as it uses the impressionsist module. any such controller would do.
describe PostsController do
    
  before do
    @impression_count = Impression.all.size
  end
  
  it "should ignore uniqueness if not requested" do
    controller.impressionist_subapp_filter(nil, nil)
    controller.impressionist_subapp_filter(nil, nil)
    Impression.should have(@impression_count + 2).records
  end
  
  it "should recognize session uniqueness" do
    # the following line was necessary as session hash returned a binary string (ASCII-8BIT encoded)
    # not sure how to 'fix' this. setup/config issue?
    controller.stub!(:session_hash).and_return(request.session_options[:id].encode("ISO-8859-1"))
    controller.impressionist_subapp_filter(nil, [:session_hash])
    controller.impressionist_subapp_filter(nil, [:session_hash])
    Impression.should have(@impression_count + 1).records
  end
  
  it "should recognize ip uniqueness" do
    controller.stub!(:action_name).and_return("test_action")
    controller.impressionist_subapp_filter(nil, [:ip_address])
    controller.impressionist_subapp_filter(nil, [:ip_address])
    Impression.should have(@impression_count + 1).records
  end
  
  it "should recognize request uniqueness" do
    controller.impressionist_subapp_filter(nil, [:request_hash])
    controller.impressionist_subapp_filter(nil, [:request_hash])
    Impression.should have(@impression_count + 1).records
  end
  
  it "should recognize action uniqueness" do
    controller.stub!(:action_name).and_return("test_action")
    controller.impressionist_subapp_filter(nil, [:action_name])
    controller.impressionist_subapp_filter(nil, [:action_name])
    Impression.should have(@impression_count + 1).records
  end
  
  it "should recognize controller uniqueness" do
    controller.stub!(:controller_name).and_return("test_controller")
    controller.impressionist_subapp_filter(nil, [:controller_name])
    controller.impressionist_subapp_filter(nil, [:controller_name])
    Impression.should have(@impression_count + 1).records
  end
  
   it "should recognize user uniqueness" do
    controller.stub!(:user_id).and_return(1)
    controller.impressionist_subapp_filter(nil, [:user_id])
    controller.impressionist_subapp_filter(nil, [:user_id])
    Impression.should have(@impression_count + 1).records
  end
  
  it "should recognize referrer uniqueness" do
    controller.stub!(:referrer).and_return("http://somehost.someurl.somdomain/some/path")
    controller.impressionist_subapp_filter(nil, [:referrer])
    controller.impressionist_subapp_filter(nil, [:referrer])
    Impression.should have(@impression_count + 1).records
  end
  
  # extra redundant test for important controller and action combination.
  it "should recognize difference in controller and action" do
    controller.stub!(:controller_name).and_return("test_controller")
    controller.stub!(:action_name).and_return("test_action")
    controller.impressionist_subapp_filter(nil, [:controller_name, :action_name])
    Impression.should have(@impression_count + 1).records
    controller.stub!(:action_name).and_return("another_action")
    controller.impressionist_subapp_filter(nil, [:controller_name, :action_name])
    Impression.should have(@impression_count + 2).records
    controller.stub!(:controller_name).and_return("another_controller")
    controller.impressionist_subapp_filter(nil, [:controller_name, :action_name])
    Impression.should have(@impression_count + 3).records
  end
  
  it "should recognize difference in action" do
    controller.stub!(:action_name).and_return("test_action")
    controller.impressionist_subapp_filter(nil, [:action_name])
    Impression.should have(@impression_count + 1).records
    controller.stub!(:action_name).and_return("another_action")
    controller.impressionist_subapp_filter(nil, [:action_name])
    Impression.should have(@impression_count + 2).records
  end
  
  it "should recognize difference in controller" do
    controller.stub!(:controller_name).and_return("test_controller")
    controller.impressionist_subapp_filter(nil, [:controller_name])
    Impression.should have(@impression_count + 1).records
    controller.stub!(:controller_name).and_return("another_controller")
    controller.impressionist_subapp_filter(nil, [:controller_name])
    Impression.should have(@impression_count + 2).records
  end
  
  it "should recognize difference in session" do
    controller.stub!(:session_hash).and_return(request.session_options[:id].encode("ISO-8859-1"))
    controller.impressionist_subapp_filter(nil, [:session_hash])
    Impression.should have(@impression_count + 1).records
    controller.stub!(:session_hash).and_return("anothersessionhash")
    controller.impressionist_subapp_filter(nil, [:session_hash])
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


