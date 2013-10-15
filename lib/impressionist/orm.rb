##
# ** Responsability **
# It should be able to require an
# model based on an ORM's name.
# It should also sets orm_name
# to the current orm in use.
#

module Impressionist
  class ORM
    class << self

      ##
      # Composite method that requires an orm
      # file based on the name passed in.
      # It also sets @orm_name to the passed name.
      #
      def require_based_on_name(_name_)
        self.set_orm = _name_
        load_files_based_on_orm_name
      end

      def set_orm=(new_orm_name)
        @orm_name = new_orm_name.to_s
      end

      def orm_name
        @orm_name ||= "active_record" 
      end

      def load_files_based_on_orm_name
        require "impressionist/models/#{orm_name}/impression.rb"
      end

    end
  end
end
