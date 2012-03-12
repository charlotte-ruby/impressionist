require "impressionist/engine.rb"

module Impressionist
  # Define ORM
  mattr_accessor :orm
  @@orm = :active_record

  # Load configuration from initializer
  def self.setup
    yield self
  end
end
