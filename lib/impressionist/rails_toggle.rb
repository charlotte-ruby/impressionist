module Impressionist
  # Responsability
  # Toggles between rails > 3.1 < 4
  # In order to make attr_accessible available in a rails app < 4

  class RailsToggle
    # decides where or not to include attr_accessible
    def should_include?
      ask_rails || false
    end

    private

      # returns false if rails >= 4
      # true if rails < 4
      def ask_rails
        ::Rails::VERSION::MAJOR.to_i >= 4 ? false : true
      end

  end

end
