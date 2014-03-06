module Impressionist
  class Consumer

    def self.setup(data = [], options = { async: AsyncIO, processor: BorderForce, queue: Queue.new })
      self.new(options).tap do |celf|
        data.respond_to?(:each) and data.each { |d| celf.push(d) } or celf.push(data)
        celf.consume!
      end
    end

    attr_reader :queue, :async
    def initialize(options)
      @async    = options[:async]
      @queue    = options[:queue]
    end

    def push(args)
      queue.push(args)
    end

    def pop; queue.pop; end

    def size; queue.size; end

    def consume!
      async.async do
        while callable = queue.pop
          callable.call 
        end
      end
    end

  end
end
