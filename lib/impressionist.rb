require "impressionist/engine.rb"

module Impressionist
  # Define ORM
  mattr_accessor :orm, :hstore
  @@orm = :active_record
  @@hstore = false

  # Load configuration from initializer
  def self.setup
    yield self
  end
end
