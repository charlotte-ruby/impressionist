module Impressionist
  module Impressionable
    def is_impressionable
      has_many :impressions, :as=>:impressionable
      include InstanceMethods
    end
    
    module InstanceMethods
      def impressionable?
        true
      end
      
      def impressionist_count(options={})
        options.reverse_merge!(:filter=>:request_hash, :start_date=>nil, :end_date=>Time.now)
        imps = options[:start_date].blank? ? impressions : impressions.where("created_at>=? and created_at<=?",options[:start_date],options[:end_date])
        if options[:filter]!=:all
          imps = imps.select(options[:filter]).group(options[:filter])
        end
        imps.all.size
      end
      
      # OLD METHODS - DEPRECATE IN V0.5
      def impression_count(start_date=nil,end_date=Time.now)
        impressionist_count({:start_date=>start_date, :end_date=>end_date, :filter=>:all})
      end

      def unique_impression_count(start_date=nil,end_date=Time.now)
        impressionist_count({:start_date=>start_date, :end_date=>end_date, :filter=> :request_hash})
      end
      
      def unique_impression_count_ip(start_date=nil,end_date=Time.now)
        impressionist_count({:start_date=>start_date, :end_date=>end_date, :filter=> :ip_address})
      end
      
      def unique_impression_count_session(start_date=nil,end_date=Time.now)
        impressionist_count({:start_date=>start_date, :end_date=>end_date, :filter=> :session_hash})
      end
    end
  end
end
