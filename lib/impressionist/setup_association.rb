# frozen_string_literal: true

module Impressionist
  class SetupAssociation
    def initialize(receiver)
      @receiver = receiver
    end

    def define_belongs_to
      receiver.belongs_to(:impressionable, polymorphic: true, optional: true)
    end

    def set
      define_belongs_to
    end

    private

    attr_reader :receiver
  end
end