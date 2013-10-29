require 'minitest_helper'
require 'impressionist/async_consumer'

Impressionist::AsyncConsumer.class_eval do
  ##
  # In order to facilitate tests
  # we have to define a few attr_writers
  # rather than stubing objects all the time.
  #
  attr_writer :block
end

describe Impressionist::AsyncConsumer do
  let(:alien) { Impressionist::AsyncConsumer.new }
  before { alien.wait_thread_to_finish! }

  describe "Block" do
    let(:bob) do
      Impressionist::AsyncConsumer.
        new { |hiya| hiya }
    end

    it { bob.must_respond_to :block }

    it "must yield content of block" do
      bob.block.call(:hiya).must_equal(:hiya)
    end
  end

  describe "Queue" do
    it { alien.must_respond_to :queue }
    it { alien.queue.must_be_kind_of(Queue) }

    it "must push contents to queue" do
      alien.push("Test")
      alien.queue.shift.must_equal("Test")
    end
  end

  describe "Thread" do
    it { alien.must_respond_to :thread }

    it { alien.thread.must_respond_to :join }

    it { alien.thread.alive?.must_equal true }

    ##
    # NOTE:
    # Thread#join returns nil if limit seconds have past
    # in this case the thread is sleeping for 0.0001 and
    # we're not waiting at all. Therefore it returns nil
    #
    it "must not wait until thread is finished" do
      alien.stub(:thread, Thread.new { sleep 0.0001 }) do
        alien.wait_thread_to_finish!.must_equal(nil)
      end
    end

    ##
    # Thread#join returns the thr if it's finished within
    # the limit seconds specified.
    #
    it "must accept time to wait" do
      alien.stub(:thread, Thread.new { :im_finished! }) do
        alien.wait_thread_to_finish!(1).
          must_equal(alien.thread)
      end
    end
  end

  describe "Mutex" do
    it { alien.must_respond_to :mutex }

    it { alien.mutex.must_be_kind_of Mutex }

    it { alien.mutex.must_respond_to :synchronize }
  end

  describe "Consuming" do

    ##
    # NOTE:
    # I could've used rspec stub, and stubed
    # out #block, or even passed it in while
    # initialising the object, but I wanted
    # to play around with ruby.
    #
    it "must consume data in queue" do
      alien.block = ->(*args) { }
      alien.push [ :test ]
      alien.push nil
      alien.wait_thread_to_finish!(1)
      alien.queue.size.must_equal(0)
    end

  end

  describe "Avoiding Race condition" do

    describe "Lock","with Mutex" do
      before { alien.block = ->(*a) { } }
      it { alien.must_respond_to :finished? }

      it "must be finished when initialised" do
        alien.finished?.must_equal true
      end

      it "must not be finished while pushing to queue" do
        alien.push(:im_going)
        alien.push(nil)
        alien.finished?.must_equal false
        alien.consume
      end

      it "must be finished when all consumed" do
        alien.push(:gonna_finish)
        alien.push(nil)
        alien.consume
        alien.finished?.must_equal true
      end

    end

    describe "Background Processsing" do
      let(:caw) { Impressionist::AsyncConsumer }

      it { caw.must_respond_to :bg_process }

      it "must not block IO" do
        call_me = Minitest::Mock.new
        call_me.expect(:call, true, [ :been_called ])
        caw.bg_process( call_me ) { |c| c.call(:been_called) }
        caw.wait
      end
    end

  end

end
