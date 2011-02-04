require 'spec_helper'

describe Impressionist do
  it "should be extended from ActiveRecord::Base" do
    ActiveRecord::Base.methods.include?(:is_impressionable).should be true
  end
  
  it "should include methods in ApplicationController" do
    ApplicationController.instance_methods.include?(:impressionist).should be true
  end
  
  it "should include the before_filter method in ApplicationController" do
     filters = ApplicationController._process_action_callbacks.select { |c| c.kind == :before }
     filters.collect{|filter|filter.filter}.include?(:impressionist_app_filter).should be true
  end
end