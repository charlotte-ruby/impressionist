require 'minitest_helper'
require 'impressionist/setup_association'

module Impressionist
  describe SetupAssociation do

    let(:mock)  { Minitest::Mock.new }
    let(:set_up) { SetupAssociation.new(mock) }

    before do
      # expects attr_accessible to return true
      # and pass 12 arguments
      mock.
        expect(:attr_accessible, true) do |args|
          args.size == 12
        end

    end

    describe "attr_accessible" do

      it "includes" do
        set_up.stub :toggle, true do
          set_up.include_attr_acc?.must_equal true

          mock.verify
        end
      end

    end

    describe "belongs_to" do

      it "active_record" do
        mock.expect(:belongs_to, true, [Symbol, Hash])
        set_up.define_belongs_to.must_equal true
      end

    end

    describe "#set" do

      it "sets an association" do
        def set_up.include_attr_acc?; true; end

        set_up.stub(:define_belongs_to, true) {
          set_up.set.must_equal true
        }

      end

    end
    # returns done if thruthy

  end
end
