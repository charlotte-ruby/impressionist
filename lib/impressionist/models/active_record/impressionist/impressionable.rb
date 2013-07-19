module Impressionist

  module Impressionable

  # extends AS::Concern
  include Impressionist::IsImpressionable
  end

end

ActiveRecord::Base.
send(:include, Impressionist::Impressionable)
