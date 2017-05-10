class Post < ActiveRecord::Base
  is_impressionable(dependent_destroy: false)
end
