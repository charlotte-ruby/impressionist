# Responsability
  # Test whether rails version > 4
  # includes attr_accessible if < 4
require 'minitest_helper'
require 'impressionist/rails_toggle'

module Impressionist
  describe RailsToggle do

    before {
      @toggle = RailsToggle.new
    }

    describe "Rails 4" do

      # see your_minitest_path/lib/minitest/mock.rb
      it "must not include attr_accessible" do
        @toggle.stub :supported_by_rails?, false do
          refute @toggle.should_include?
        end
      end

    end

    describe "Strong Parameters" do

      # see your_minitest_path/lib/minitest/mock.rb
      it "must not include attr_accessible" do
        @toggle.stub :supported_by_rails?, true do
          @toggle.stub :using_strong_parameters?, true do
            refute @toggle.should_include?
          end
        end
      end

    end
  end
end
