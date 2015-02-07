class Profile < ActiveRecord::Base
  extend FriendlyId

  friendly_id :username, use: :slugged
  is_impressionable
end
