require 'spec_helper'
require 'impressionist'

describe Impressionist do
  # default db
  before do
    Impressionist.stub(:orm).and_return(:active_record)
  end

  it { should respond_to(:mattr_accessor) }

  it { should respond_to(:orm) }
  its(:class_variables) { should include(:@@orm) }

  its(:orm) { should eq(:active_record) }


  context "Overriding default config" do

    it { should respond_to(:setup) }

    it "overrides default config" do
      Impressionist.should_receive(:orm=).and_return(:my_db_name)
      Impressionist.setup { |s| s.orm = :my_db_name }
    end


  end

end

