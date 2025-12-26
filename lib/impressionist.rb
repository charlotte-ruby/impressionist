# frozen_string_literal: true

require 'impressionist/load'

module Impressionist
  # Define default ORM
  mattr_accessor :orm
  @@orm = :active_record

  # Security: Maximum size for stored params (default 10KB)
  mattr_accessor :max_params_size
  @@max_params_size = 10_240

  # Security: Allowlist for impressionable types
  mattr_accessor :allowed_impressionable_types
  @@allowed_impressionable_types = nil

  # Security: Enable/disable logging options
  mattr_accessor :log_ip_address
  @@log_ip_address = true

  mattr_accessor :log_referrer
  @@log_referrer = true

  mattr_accessor :log_params
  @@log_params = true

  mattr_accessor :log_session_hash
  @@log_session_hash = true

  # Load configuration from initializer
  def self.setup
    yield self
  end

  def self.valid_impressionable_type?(type)
    return true if allowed_impressionable_types.nil?

    allowed_impressionable_types.include?(type)
  end
end