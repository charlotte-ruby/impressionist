##
# Responsability
# Subscribes to a particular instrumentation and
# pushes that instrumentation's payload onto queue.
#
# Default is ActionSupport::Notifications which accepts
# and object that responds to +call+, in this case our
# Impressionist::Consumer does respond to call, thus pushing
# data onto queue.
#
module Impressionist
  class Subscriber

    def self.setup(options = { subscriber: ActionSupport::Notifications, consumer: Consumer.setup })
      self.new options
    end

    attr_reader :subscriber, :consumer

    def initialize(options)
      @subscriber = options[:subscriber]
      @consumer   = options[:consumer]
    end

    def subscribe(instrumentation)
      subscriber.subscribe(instrumentation, consumer)
    end

  end
end
