##
# Responsability
#
# Consumes all objects stored in queue, by default calls +call+ method on BorderForce
# Which holds a instrumentation's payload.
#
module Impressionist
  class Consumer

    def self.setup(data = [], options = { async: AsyncIO, processor: BorderForce, queue: Queue.new })
      self.new(options).tap do |inst|
        data.respond_to?(:each) and inst.each { |d| inst.push(d) } or inst.push(data)
        inst.consume!
      end
    end

    attr_reader :queue, :async, :processor
    def initialize(options)
      @async      = options[:async]
      @queue      = options[:queue]
      @processor  = options[:processor]
    end

    def call(arguments)
      push( processor.new(arguments) )
    end

    def push(args); queue.push(args); end
    def pop; queue.pop;               end
    def size; queue.size;             end

    def consume!
      async.async do
        while callable = queue.pop
          callable.call 
        end
      end
    end

  end
end
