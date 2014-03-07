require 'spec_helper'
require 'active_support/notifications'
require 'impressionist/minion/instrumentation'

class Instrumenter
  include Impressionist::Minion::Instrumentation

  attr_writer :notifier
  # Stub some Rails Metal methods
  def action_name; :index; end

  def controller_name; "TestController"; end

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
  def remote_ip; '127.0.0.1'; end

  def self.impressionable; { actions: [:index, :edit] }; end

  public( :imp_instrumentation, :raw_payload,
          :impressionable_hash, :notifier,
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

    it "must have a notifier" do
      redbull.notifier.should_not be_nil
    end

    class ActiveSupport; Notifications = Class.new; end
    it "s notifications must be As::Notifications" do
      redbull.notifier.should eq ::ActiveSupport::Notifications
    end

    describe ".raw_payload" do
      let(:raw_payload) { redbull.raw_payload }

      it "must include action" do
        raw_payload[:action_name].should eq :index
      end

      it "must include user_id" do
        raw_payload[:user_id].should eq :none
      end

      it "must include format" do
        raw_payload[:format].should eq :html
      end

      it "must include controller_name" do
        raw_payload[:controller_name].should eq "TestController"
      end

      it "must include path" do
        raw_payload[:path].should eq "unknown"
      end

      it "must include http status code" do
        raw_payload[:status].should eq 200
      end

      it "must include USER_AGENT" do
        raw_payload[:user_agent].should eq 'USER_AGENT'
      end

      it "must include ip_address" do
        raw_payload[:ip_address].should eq '127.0.0.1'
      end

    end

    describe "Append extra info to impressionist payload" do

      it "must append_to_imp_payload" do
        redbull.notifier = MockInstrument.new

        def redbull.append_to_imp_payload(payload)
          payload[:info] = :goes_here
        end

        redbull.imp_instrumentation[:payload][:info].should eq :goes_here
      end

    end

    describe "Instrumenting" do

      before { redbull.notifier = MockInstrument.new }

      it "must have instrument's name" do
        redbull.imp_instrumentation[:name].should eq "process_impression.impressionist"
      end

      it "must have a payload" do
        redbull.imp_instrumentation[:payload].should eq redbull.raw_payload
      end

    end

    describe "impressionable_hash" do
      it "must get impressionable hash of contents" do
        redbull.impressionable_hash.should eq({ actions: [:index, :edit] })
      end
    end

    describe "Merges impressionable_hash into raw_payload" do
      it "must merge the two hashes" do
        redbull.raw_payload[:actions].should eq [:index, :edit]
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

      before do
        def coke.impressionable
          { hook: :before, actions: [ :edit, :show ] }
        end
      end

      it "must instrument for a default hook" do
       coke.should_receive(:before_action).
        with( :imp_instrumentation, only: [ :edit, :show ] )

        coke.set_impressionist_instrumentation
      end

      it "must instrument for a different hook" do
        coke.stub(:impressionable).and_return({ hook: :after })
        coke.should_receive(:after_action)
        coke.set_impressionist_instrumentation
      end

    end

  end

end
