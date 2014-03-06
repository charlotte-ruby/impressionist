require 'spec_helper'
require 'impressionist/subscriber'
require 'impressionist/consumer'

class FakeSubscriber
  def subscribe(n,x); x.call; end
end

describe Impressionist::Subscriber do
  let!(:subscriber) { Impressionist::Subscriber.setup( { subscriber: FakeSubscriber.new, consumer: FakeConsumer.new } ) }

  context ".subscribe" do
    it "subscribes to an instrumentation" do
      subscriber.subscriber.should_receive(:subscribe)
      subscriber.subscribe("test")
    end

    it "pushes payload onto queue" do
      subscriber.consumer.should_receive(:call)
      subscriber.subscribe("test")
    end
  end


  context "Setup", "default options value" do
    let(:new_subscriber) do
      Impressionist::Consumer.should_receive(:setup).and_return(FakeConsumer.new)
      Impressionist::Subscriber.setup
    end

    it { new_subscriber.subscriber.should eq ActionSupport::Notifications }

    it { new_subscriber.consumer.should be_a FakeConsumer }

  end

end
