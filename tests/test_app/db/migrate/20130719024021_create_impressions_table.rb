class CreateImpressionsTable < ActiveRecord::Migration
  def self.up
    create_table :impressions, force: true do |t|
      t.string :impressionable_type, limit: 191
      t.integer :impressionable_id
      t.integer :user_id
      t.string :controller_name, limit: 191
      t.string :action_name, limit: 191
      t.string :view_name, limit: 191
      t.string :request_hash, limit: 191
      t.string :ip_address, limit: 191
      t.string :session_hash, limit: 191
      t.text :message
      t.text :referrer
      t.text :user_agent
      t.text :params
      t.timestamps
    end
    add_index :impressions, [:impressionable_type, :message, :impressionable_id], name: 'impressionable_type_message_index', unique: false, length: { message: 191 }
    add_index :impressions, [:impressionable_type, :impressionable_id, :request_hash], name: 'poly_request_index', unique: false
    add_index :impressions, [:impressionable_type, :impressionable_id, :ip_address], name: 'poly_ip_index', unique: false
    add_index :impressions, [:impressionable_type, :impressionable_id, :session_hash], name: 'poly_session_index', unique: false
    add_index :impressions, [:controller_name, :action_name, :request_hash], name: 'controlleraction_request_index', unique: false
    add_index :impressions, [:controller_name, :action_name, :ip_address], name: 'controlleraction_ip_index', unique: false
    add_index :impressions, [:controller_name, :action_name, :session_hash], name: 'controlleraction_session_index', unique: false
    add_index :impressions, :user_id
  end

  def self.down
    drop_table :impressions
  end
end
