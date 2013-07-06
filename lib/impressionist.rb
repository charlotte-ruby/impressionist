require 'impressionist/load'

module Impressionist
  # Define default ORM
  mattr_accessor :orm
  @@orm = :active_record

  # Load configuration from initializer
  def self.setup
    yield self
  end
end
