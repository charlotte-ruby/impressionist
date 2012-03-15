class Impression
  include MongoMapper::Document

  key :impressionable_type, String
  key :impressionable_id, String
  key :user_id, String
  key :controller_name, String
  key :action_name, String
  key :view_name, String
  key :request_hash, String
  key :ip_address, String
  key :session_hash, String
  key :message, String
  key :referrer, String
  timestamps!
end
