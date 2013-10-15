require 'minitest_helper'
require 'impressionist/orm'

describe Impressionist::ORM do

  parallelize_me!

  let(:steve) { Impressionist::ORM }
  let(:sean)  { Impressionist::ORM.dup }
  let(:paul)  { Impressionist::ORM.dup }

  before do
    ##
    # Stubs require method to return
    # the a string which is the path that
    # would be required.
    #
    def steve.require(name)
      name
    end
  end

  def imp_path(name)
    "impressionist/models/#{name.to_s}/impression.rb"
  end


  it "must have active_record as default orm" do
    steve.orm_name.must_equal "active_record"
  end

  it "must load files based on orm's name" do
    steve.set_orm = "active_record"

    steve.load_files_based_on_orm_name
  end

  it "must require based on name" do
    steve.require_based_on_name(:active_record).
      must_equal imp_path(:active_record)
  end

  it "must change orm's name" do
    sean.set_orm = "mongoid"

    sean.orm_name.must_equal "mongoid"
  end

  it "must load_files_based on :test name" do
    paul.require_based_on_name(:test).
      must_equal imp_path(:test)
  end

end
