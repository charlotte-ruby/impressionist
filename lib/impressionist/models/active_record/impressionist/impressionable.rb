# frozen_string_literal: true

module Impressionist
  module Impressionable
    include Impressionist::IsImpressionable
  end
end

ActiveRecord::Base.include(Impressionist::Impressionable)