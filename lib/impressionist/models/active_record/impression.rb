# frozen_string_literal: true

class Impression < ActiveRecord::Base
  include Impressionist::CounterCache

  Impressionist::SetupAssociation.new(self).set

  store :params

  before_save :sanitize_attributes
  after_save :impressionable_counter_cache_updatable?

  private

  def sanitize_attributes
    self.controller_name = controller_name&.slice(0, 255)
    self.action_name = action_name&.slice(0, 255)
    self.view_name = view_name&.slice(0, 255) if respond_to?(:view_name) && view_name.present?
    self.request_hash = request_hash&.slice(0, 255)
    self.session_hash = session_hash&.slice(0, 255)
    self.ip_address = ip_address&.slice(0, 45)
    self.referrer = referrer&.slice(0, 2048)
    self.message = message&.slice(0, 1024) if respond_to?(:message) && message.present?
  end
end