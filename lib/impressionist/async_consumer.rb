module Impressionist
  class AsyncConsumer

    ##
    # TODO: remove this
    #
    class << self
      attr_reader :thread

      def bg_process(to_be_processed, &block)
        @thread = Thread.new(to_be_processed) { |p| block.call(p) }
      end

      def wait
        thread.join
      end
    end

    ##
    # Returns arguments passed on to the queue
    # For example:
    # @name = "Antonio C Nalesso"
    # @a ||= AnagramSolver::AsyncConsumer.new do |*args|
    #   sleep(1)
    #   print args.join(", ")
    # end
    #
    # @a.push([ "My name is", @name ])
    # print :Hurray
    # => Hurray
    # => My name is Antonio C Nalesso
    #
    attr_reader :queue, :thread
    attr_reader :block, :mutex

    def initialize(queue=Queue.new, &block)
      @queue  = queue
      @mutex  = Mutex.new
      @lock   = true
      @block  = block
      @thread = Thread.new { consume }
    end

    ##
    # Consumes data from a queue.
    # NOTE: As it use a while loop, We would
    # have to find a way of stoping the loop.
    # A common way would be pushing nil to
    # queue and then it would exit.
    # If I didn't pass nil it would raise:
    #   Failure/Error:
    #   (anonymous error class);
    #   No live threads left. Deadlock?
    # As there's nothing in queue.
    #
    def consume
      while (args = queue.shift)
        block.call(args)
      end
      mutex.synchronize { @lock  = queue.empty? }
    end

    ##
    # Pushes args in to a queue.
    #
    def push(*args)
      queue.push(*args)
      mutex.synchronize { @lock = false }
    end

    ##
    # Waits for a thread to finish
    # returns nil if limit seconds have past.
    # or returns thread itself if thread was
    # finished  whithing limit seconds.
    #
    # If you call it without a limit second,
    # it will use 0 as default, therefore it
    # will not wait thread to finish, and it
    # will return nil.
    # (i.e Stops main thread ( current one )
    # and waits until the other thread is finished,
    # then passes execution to main thread again. )
    #
    def wait_thread_to_finish!(ttw=0)
      thread.join(ttw)
    end

    def finished?
      lock
    end

    private
      attr_reader :lock

  end
end
