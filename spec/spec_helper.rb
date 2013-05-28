module Impressionist
  def self.mattr_accessor(accessor)
    class_variable_set("@@#{accessor}", accessor)
  end
end
