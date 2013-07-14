# Use this hook to configure impressionist parameters
#Impressionist.setup do |config|
  # Define ORM. Could be :active_record (default), :mongo_mapper or :mongoid
  # config.orm = :active_record
#end

<% orm = options.orm.match(/mongoid|active_record|mongomapper/) %>
<%= "Impressionist.orm = :#{options.orm}" if  String === options.orm %>
