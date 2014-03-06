require 'spec_helper'
require 'impressionist/consumer'

describe Impressionist::Consumer do

  let!(:options)  { { async: FakeAsync, queue: Queue.new, processor: FakeBorderForce } }
  let!(:consumer) { Impressionist::Consumer.new( options ) }

  describe "Pushing data" do

    it "stores data to be consumed" do
      consumer.push(1)
      consumer.push(2)
      consumer.size.should eq 2
    end

    it "pushes instances of processor objects onto queue via call" do
      consumer.processor.should_receive(:new).with(2)
      consumer.call(2)
    end
  end

  describe "Retrieving stored data" do
    it "#pops" do
      data = { data: [] }
      consumer.push( data )
      consumer.pop.should eq data
    end
  end

  describe "Consuming stored data" do
    it "consumes any data stored in queue" do
      fake_data = double("FakeData")
      fake_data.should_receive(:call)
      new_consumer = Impressionist::Consumer.setup(fake_data, { async: FakeAsync.new, queue: FakeQueue.new })
    end

    context "Errors" do
      it "logs errors but not raise" do
        AsyncIO::Logger.should_receive(:error)
        errored = -> { raise "Won't be raised" }
        Impressionist::Consumer.setup(errored, { async: FakeAsync.new, queue: FakeQueue.new })
      end
    end
  end

end
