class CreateImpressionsTable < ActiveRecord::Migration
  def self.up
    create_table :impressions, :force => true do |t|
      t.string :impressionable_type
      t.integer :impressionable_id
      t.integer :user_id
      t.string :controller_name
      t.string :action_name
      t.string :view_name
      t.string :request_hash
      t.string :ip_address
      t.string :session_hash
      t.text :message
      t.text :referrer
      t.timestamps
    end
    add_index :impressions, [:impressionable_type, :impressionable_id, :request_hash], :name => "poly_request_index", :unique => false
    add_index :impressions, [:impressionable_type, :impressionable_id, :ip_address], :name => "poly_ip_index", :unique => false
    add_index :impressions, [:impressionable_type, :impressionable_id, :session_hash], :name => "poly_session_index", :unique => false
    add_index :impressions, [:controller_name,:action_name,:request_hash], :name => "controlleraction_request_index", :unique => false
    add_index :impressions, [:controller_name,:action_name,:ip_address], :name => "controlleraction_ip_index", :unique => false
    add_index :impressions, [:controller_name,:action_name,:session_hash], :name => "controlleraction_session_index", :unique => false
    add_index :impressions, :user_id
  end

  def self.down
    remove_index :impressions, :name => :poly_request_index
    remove_index :impressions, :name => :poly_ip_index
    remove_index :impressions, :name => :poly_session_index
    remove_index :impressions, :name => :controlleraction_request_index
    remove_index :impressions, :name => :controlleraction_ip_index
    remove_index :impressions, :name => :controlleraction_session_index
    remove_index :impressions, :user_id

    drop_table :impressions
  end
end