# Responsability
# * be able to update_counters
# * log an error if imps_id and imps_type can not be found
# asks updatable? whether it may or may not be updated
# FIX exeception raising when no imps_id is found

class Impression < ActiveRecord::Base
  include Impressionist::CounterCache
  include Impressionist::SetUpAssociation

  after_save :impressionable_counter_cache_updatable?

end
