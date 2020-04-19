
require 'spec_helper'
require 'impressionist/rails_toggle'


describe Impressionist do
  describe Impressionist::RailsToggle do
    let(:toggle) { Impressionist::RailsToggle.new }

    context "when using rails < 4" do
      it "will be included" do
        stub_const("::Rails::VERSION::MAJOR", 3)

        expect(toggle.should_include?).to be_truthy
      end

      it "will not be included when strong parameters is defined" do
        stub_const("::Rails::VERSION::MAJOR", 3)
        stub_const("StrongParameters", Module.new)

        expect(toggle.should_include?).to be_falsy
      end
    end

    context "when using rails >= 4" do
      it "will not be included" do
        stub_const("::Rails::VERSION::MAJOR", 4)

        expect(toggle.should_include?).to be_falsy
      end
    end
  end
end


# Responsability
  # Test whether rails version > 4
  # includes attr_accessible if < 4


  # module Impressionist
  #   describe RailsToggle do
  #     before {
  #       @toggle = RailsToggle.new
  #     }

  #     describe "Rails 4" do
  #       # see your_minitest_path/lib/minitest/mock.rb
  #       it "must not include attr_accessible" do
  #         @toggle.stub :supported_by_rails?, false do
  #           refute @toggle.should_include?
  #         end
  #       end

  #     end

  #     describe "Strong Parameters" do

  #       # see your_minitest_path/lib/minitest/mock.rb
  #       it "must not include attr_accessible" do
  #         @toggle.stub :supported_by_rails?, true do
  #           @toggle.stub :using_strong_parameters?, true do
  #             refute @toggle.should_include?
  #           end
  #         end
  #       end

  #     end
  #   end
  # end
