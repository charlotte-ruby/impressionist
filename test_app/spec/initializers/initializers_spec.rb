require 'spec_helper'

describe Impressionist do
  it "should be extended from ActiveRecord::Base" do
    method = RUBY_VERSION.match("1.8") ? "is_impressionable" : :is_impressionable
    ActiveRecord::Base.methods.include?(method).should be_true
  end

  it "should include methods in ApplicationController" do
    method = RUBY_VERSION.match("1.8") ? "impressionist" : :impressionist
    ApplicationController.instance_methods.include?(method).should be_true
  end

  it "should include the before_filter method in ApplicationController" do
     filters = ApplicationController._process_action_callbacks.select { |c| c.kind == :before }
     filters.collect{|filter|filter.filter}.include?(:impressionist_app_filter).should be_true
  end
end
