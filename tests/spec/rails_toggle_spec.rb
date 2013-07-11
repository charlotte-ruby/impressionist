# Responsability
  # Test whether rails version > 4
  # includes attr_accessible if < 4
require 'test_helper.rb'
require 'impressionist/rails_toggle'

module Impressionist
  describe RailsToggle do

    describe "Rails 4" do
      before do
        @toggle = RailsToggle.new("4")
      end

      it "return current rails version" do
        @toggle.r_version.must_equal "4"
      end

      it "must not load attr_accessible" do
        @toggle.valid?.must_equal false
      end

    end

    describe "Rails 3.1.x" do

      before do
        @toggle = RailsToggle.new("3")
      end

      it "includes" do
         @toggle.valid?.must_equal true
      end
    end

  end

end
