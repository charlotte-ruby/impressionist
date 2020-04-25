require 'spec_helper'

describe Impressionist do
  let(:imp) { RUBY_VERSION.match("1.8") ? "is_impressionable" : :is_impressionable }

  it "is extended from ActiveRecord::Base" do
    expect(ActiveRecord::Base).to respond_to(imp)
    # ActiveRecord::Base.methods.include?(method).should be_truthy
  end

  it "includes methods in ApplicationController" do
    method = RUBY_VERSION.match("1.8") ? "impressionist" : :impressionist
    expect(ApplicationController).to respond_to(method)
  end

  it "includes the before_action method in ApplicationController" do
    filters = ApplicationController._process_action_callbacks.select { |c| c.kind == :before }

    expect(filters.collect(&:filter)).to include(:impressionist_app_filter)
  end
end
