# frozen_string_literal: true

require 'impressionist/load'
require 'impressionist/engine'

module Impressionist
  mattr_accessor :orm
  @@orm = :active_record

  mattr_accessor :max_params_size
  @@max_params_size = 10_240

  mattr_accessor :allowed_impressionable_types
  @@allowed_impressionable_types = nil

  mattr_accessor :log_ip_address
  @@log_ip_address = true

  mattr_accessor :log_referrer
  @@log_referrer = true

  mattr_accessor :log_params
  @@log_params = true

  mattr_accessor :log_session_hash
  @@log_session_hash = true

  def self.setup
    yield self
  end

  def self.valid_impressionable_type?(type)
    return true if allowed_impressionable_types.nil?
    allowed_impressionable_types.include?(type)
  end
end