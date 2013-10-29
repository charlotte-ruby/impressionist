require 'impressionist/minion/methods'

module Impressionist
  module Minion

  ##
  # Responsability
  # Add a minion ( i.e impressionable?, impressionable )
  # impressionable methods whereas
  # impressionable? returns true
  # impressionable returns a hash of contents
  #
  # Also instrument a notification to be subscribed
  # in order to gather info from a Controller
  # to save an impression.
  # process_impression.impressionist works pretty much like
  # process_action.action_controller, one can subscribe to them.
  # check out Impressionist::Minion::Instrumentation
  #
  # Rationale:
  #
  # Impressionist::MinionCreator.banana_potato
  # add(:controller_name, :actions, :options)
  #
  # add(:posts, "index", :show, unique: true, counter_cache: true)
  #
  # By default it uses its name ( :users here )
  # as its class_name ( Model ). One can change it by passing
  # a model to class_name option.
  # add(:users, "index", class_name: Clients, counter_cache: true)
  #
  # By default it uses Impressionist::ImpressionsCache.
  # add(:pringles, "index", counter_cache: true, cache_class: MyOwnCache)
  #
  # impressions_total is the default.
  # add(:comments, "index", counter_cache: true, column_name: :cached_impressions)
  # end
  #
  # You must pass what actions you to save impressions for,
  # as Impressionist uses before_filter to instrument notifications.
  # TODO: add filter option to swap between before|after filters.

  module MinionCreator
    extend Methods

    ##
    # instance_eval sets self back to
    # the origin object, allowing us
    # to call the method add without passing
    # any parameter to the block.
    #
    # MinionCreator.banana_potato do
    #   add ...
    # end

    class << self
      alias :banana_potato :instance_eval
    end
  end

  end
end
