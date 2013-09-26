require 'impressionist/minion/instrumentation'

module Impressionist
  module Minion
    module Methods
      attr_reader :name, :options, :actions

      # Adds a new minion ( impressionable method )
      # to a particular entity ( i.e Controller )
      # BTW extract_options! ROCKS!!!
      def add(name, *options)
        @name     = name
        @actions  = options
        @options  = actions.extract_options!
        add_impressionable_method
      end

      private

      ##
      # Add impressionable method to a given
      # class object with its hash of options.
      # Includes Instrumentation.
      # Reset parameters after adding.
      # controller = PostsController
      # PostsController.instance_exec( params ) do |param|
      #   self is set to the class object
      # end
      def add_impressionable_method
        controller.instance_exec(generate_hash) do |body|
          define_singleton_method(:impressionable) { body }

          include Impressionist::Minion::Instrumentation
          set_impressionist_instrumentation
        end

        reset_parameters!
      end

      ##
      # Generates a hash for impressionable method.
      def generate_hash
        { name: name,
          actions: actions,
          unique: unique,
          counter_cache: counter_cache,
          class_name: class_name,
          cache_class: cache_class,
          column_name: column_name }
      end

      ##
      # Saves impressions based on unique type
      # default is :ip_address if unique is set
      # to true
      def unique
        _unique = options[:unique] || false
        _unique === true ? :ip_address : _unique
      end

      ##
      # Default is false, if true it will
      # update_counters.
      def counter_cache
        options[:counter_cache] || false
      end

      ##
      # If class_name is passed it uses as default
      # otherwise it uses a minion's (controller)
      # name. This is the Model object.
      def class_name
        options[:class_name] || get_constant(name.to_s.classify)
      end

      ##
      # Sets entity that should update_counters
      # if counter_cache is set to true
      # Default is Impressionist::ImpressionsCache
      def cache_class
        options[:cache_class] || get_constant("Impressionist::ImpressionsCache")
      end

      ##
      # Default is :impressions_total, However it
      # can be modified.
      def column_name
        options[:column_name] || :impressions_total
      end

      ##
      # Gets a controller entity
      # 'posts_controller'.classify
      # PostsController
      def controller
        _controller = name.to_s + "_controller"
        get_constant _controller.classify
      end

      def get_constant(_name)
        _name.safe_constantize
      end

      ##
      # Resets parameters, as it uses only
      # one instance to add minions.
      def reset_parameters!
        @name     = ""
        @options  = {}
        @actions  = []
      end

      def options
        @options ||= Hash.new
      end

    end
  end
end
