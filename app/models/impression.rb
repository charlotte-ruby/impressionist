class Impression < ActiveRecord::Base
  belongs_to :impressionable, :polymorphic=>true
end