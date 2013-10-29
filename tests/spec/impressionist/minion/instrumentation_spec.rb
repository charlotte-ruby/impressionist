require 'minitest_helper'
require 'active_support/notifications'
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

  def user_agent; 'USER_AGENT'; end
  def ip_address; '127.0.0.1'; end

  def self.impressionable; { actions: [:index, :edit] }; end
  # Make private methods public
  # in order to better test them
  public( :imp_instrumentation, :raw_payload,
          :impressionable_hash, :notifications,
          :append_to_imp_payload )
end

##
# Fakes AS::Notifications.instrument
# if a block is given it yields its payload,
# which is a hash ( i.e raw_payload hash ).
# if not just returns the hash above.
#
class MockInstrument
  def instrument(name, payload={})
    yield(payload) if block_given?
    { name: name, payload: payload }
  end
end


module Impressionist
  describe Minion::Instrumentation do
    let(:redbull) { Instrumenter.new }

    it "must respond to instrument" do
      redbull.must_respond_to :imp_instrumentation
    end

    it "must respond to get_impressionable" do
      redbull.must_respond_to :impressionable_hash
    end

    it "must respond to raw_payload" do
      redbull.must_respond_to :raw_payload
    end

    it "must respond to notifications" do
      redbull.must_respond_to :notifications
    end

    class ActiveSupport; Notifications = Class.new; end
    it "s notifications must be As::Notifications" do
      redbull.notifications.must_equal ::ActiveSupport::Notifications
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

      it "must include USER_AGENT" do
        raw_payload[:user_agent].must_equal 'USER_AGENT'
      end

      it "must include ip_address" do
        raw_payload[:ip_address].must_equal '127.0.0.1'
      end

    end

    describe "Append extra info to impressionist payload" do
      it "must respond ot append_to_imp_payload" do
        redbull.must_respond_to :append_to_imp_payload
      end

      it "must append_to_imp_payload" do
        redbull.notifications = MockInstrument.new
        def redbull.append_to_imp_payload(p)
          p[:extra] = :goes_here
          p[:extra].must_equal :goes_here
        end

        redbull.imp_instrumentation
      end

    end

    describe "Instrumenting" do

      before { redbull.notifications = MockInstrument.new }

      it "must have instrument's name" do
        redbull.imp_instrumentation[:name].must_equal "process_impression.impressionist"
      end

      it "must have a payload" do
        redbull.imp_instrumentation[:payload].must_equal redbull.raw_payload
      end

    end

    describe "impressionable_hash" do
      it "must get impressionable hash of contents" do
        redbull.impressionable_hash.must_equal({ actions: [:index, :edit] })
      end
    end

    describe "Merges impressionable_hash into raw_payload" do
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
          must_equal [ :imp_instrumentation, only: [ :edit, :show ] ]
      end

    end

  end

end
