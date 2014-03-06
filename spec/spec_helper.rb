require 'active_support/concern'
require 'active_support/core_ext/module/attribute_accessors'
require 'active_support/core_ext/string/inflections.rb'
require 'async_io/rescuer'

module ActionSupport
  class Notifications
  end
end

class AsyncIO::Logger; def self.error(n); end; end;

class FakeAsync
  include AsyncIO::Rescuer

  def async
    rescuer { yield }
  end
end

class FakeActionController
  class << self
    def after_action(*args); args; end
    alias_method :before_action, :after_action
    alias_method :around_action, :after_action
  end
end

class FakeQueue
  def initialize
    @queue = []
  end

  def push(n); @queue << n; end
  def pop; @queue.pop;      end
  def size; @queue.size;    end
end

FakeConsumer = FakeQueue

##
# Require support files.
#
support_path = File.
  dirname(__FILE__) + "/support/**/*.rb"

Dir[support_path].each {|f| require f }


# Fake Rails::Engine
module Rails
  class Engine
    def self.isolate_namespace(x)
      true
    end

  end
end

# I don't like writing true all the time
class BasicObject
    def must_be_true; must_equal(true); end
end

# Stubs Controller's callbacks
Object.instance_eval do
  # def after_filter(*args); args end
end

# Default Cache
ImpressionsCache = Class.new
