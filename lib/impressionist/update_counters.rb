module Impressionist
  class UpdateCounters
    attr_reader :receiver, :master

    def initialize(receiver)
      @receiver = receiver
      @master = receiver.class
    end

    def update
      result = (impressions_total - impressions_cached)

      master.
      update_counters(id, column_name => result)
    end

    private
      def id
        receiver.id
      end

      # if unique == true then uses it
      # otherwise just count all impressions
      # using filter: :all
      def impressions_total
        receiver.impressionist_count filter(unique_filter)
      end

      # from a given db column
      # default should be impressions_count
      def impressions_cached
        receiver.send(column_name) || 0
      end

      def column_name
        cache_options[:column_name].to_sym
      end

      def cache_options
        master. 
        impressionist_counter_cache_options
      end 

      # default is ip_address if what_is_unique is TRUE or FALSE 
      def unique_filter
       what_is_unique? ? :ip_address : cache_options[:unique]
      end

      # Either true or false
      # :filter gets assigned to :ip_address as default
      # One could do
      # is_impressionable :counter_cache => true, :unique => :any_other_colum
      def what_is_unique?
        cache_options[:unique].to_s =~ /true|false/
      end

      def filter(filter_will_be)
        {:filter => filter_will_be.to_sym}
      end

  end

end
