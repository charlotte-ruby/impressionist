module Impressionist
  # Responsability
  # Toggles between rails > 3.1 < 4
  # In order to make attr_accessible available in a rails app < 4
  class RailsToggle

    attr_reader :r_version

    def initialize(version)
      @r_version = version.to_s 
    end

    # if Rails 4, it does not include attr_accessible
    # and it returns false
    def valid?
      greater_than_4? ? false : true
    end

    private

      def greater_than_4?
        r_version == "4" ? true : false
      end

  end
end
