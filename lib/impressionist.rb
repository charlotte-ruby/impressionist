require 'impressionist/load'

module Impressionist
  # Define default ORM
  mattr_accessor :orm
  @@orm = :active_record

  # Load configuration from initializer
  def self.setup
    yield self
  end

  def self.deprecator
    @deprecator ||= ActiveSupport::Deprecation.new('3.0', 'Impressionist')
  end
end
