class Widget < ActiveRecord::Base
  is_impressionable :counter_cache => true, :unique => :request_hash
end
