require 'impressionist/minion/methods.rb'

class Dummy
  include Impressionist::Minion::Methods

  # Helper methods, test ^-O vim
  attr_writer :name, :options, :actions

  # Make private methods public
  # to test them
  public( :controller, :get_constant,
          :add_impressionable_method,
          :generate_hash, :options,
          :reset_parameters! )
end
