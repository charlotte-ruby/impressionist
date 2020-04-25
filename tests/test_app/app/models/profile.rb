class Profile < ApplicationRecord
  extend FriendlyId

  friendly_id :username, use: :slugged
  is_impressionable
end
