require 'minitest/autorun'
require 'minitest/pride'

require 'active_support/concern'

require 'active_support/core_ext/module/attribute_accessors'

require 'active_support/core_ext/string/inflections.rb'

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
  def after_filter(*args); args end
end
