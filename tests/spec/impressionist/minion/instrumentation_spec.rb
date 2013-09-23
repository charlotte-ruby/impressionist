require 'minitest_helper'
require 'impressionist/minion/instrumentation'

class Instrumenter
  include Impressionist::Minion::Instrumentation

  attr_writer :notifications
  # Stub some Rails Metal methods
  def action_name
    :index
  end

  # Returns self, so we it looks
  # for the following method .method_name
  # in the same object, as we don't have
  # those methods defined.
  def request; self; end

  def filtered_parameters
    { smile: :when_you_see_it }
  end

  def format; self; end

  def try(param)
    :html
  end

  def response; self; end

  def status; 200; end

  def self.impressionable; { actions: [:index, :edit] }; end
  # Make private methods public
  # in order to better test them
  public( :instrument, :raw_payload,
          :get_impressionable, :notifications )
end

module Impressionist
  describe Minion::Instrumentation do
    let(:redbull) { Instrumenter.new }

    it "must respond to instrument" do
      redbull.must_respond_to :instrument
    end

    it "must respond to get_impressionable" do
      redbull.must_respond_to :get_impressionable
    end

    it "must respond to raw_payload" do
      redbull.must_respond_to :raw_payload
    end

    it "must respond to notifications" do
      redbull.must_respond_to :notifications
    end

    class ActiveSupport; Notifications = Class.new; end
    it "s notifications must be As::Notifications" do
      redbull.notifications.must_equal ActiveSupport::Notifications
    end

    describe ".raw_payload" do
      let(:raw_payload) { redbull.raw_payload }

      it "must include action" do
        raw_payload[:action].must_equal :index
      end

      it "must include params" do
        raw_payload[:params].must_equal({ smile: :when_you_see_it })
      end

      it "must include format" do
        raw_payload[:format].must_equal :html
      end

      it "must include path" do
        raw_payload[:path].must_equal "unknown"
      end

      it "must include http status code" do
        raw_payload[:status].must_equal 200
      end

    end

    describe ".instrument" do

      ##
      # Pretends to be a payload
      # of a subscription.
      # By default when you instrument something
      # it returns its name, start_time, finished_time,
      # and a payload, see ActionSupport::Notifications
      class MockInstrument
        def instrument(name, args={})
          { name: name, payload: args}
        end
      end

      before { redbull.notifications = MockInstrument.new }

      it "must have instrument's name" do
        redbull.instrument[:name].must_equal "process_impression.impressionist"
      end

      it "must have a payload" do
        redbull.instrument[:payload].must_equal redbull.raw_payload
      end

    end

    describe ".get_impressionable" do
      it "must get details impressionable's method" do
        redbull.get_impressionable.must_equal({ actions: [:index, :edit] })
      end
    end

    describe "Merges get_impressionable into raw_payload" do
      # see line  33 of this file
      it "must merge the two hashes" do
        redbull.raw_payload[:actions].must_equal [:index, :edit]
      end
    end

    describe "Adding instrumentation" do
      class ::Cola
        include Minion::Instrumentation

        class << self
          public :set_impressionist_instrumentation
        end

      end

      let(:coke) { Cola }

      it "must respond_to set_impressionist_instrumentation" do
        coke.must_respond_to :set_impressionist_instrumentation
      end

      it "must instrument to index, :edit actions" do
        def coke.impressionable; { actions: [ :edit, :show ] }; end

        coke.set_impressionist_instrumentation.
          must_equal [ :instrument, only: [ :edit, :show ] ]
      end

    end

  end

end
