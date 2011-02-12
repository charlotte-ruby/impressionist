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
      t.string :message
      t.timestamps
    end
    add_index :impressions, [:impressionable_type, :impressionable_id, :request_hash, :ip_address], :name => "poly_index", :unique => false
    add_index :impressions, [:controller_name,:action_name,:request_hash,:ip_address], :name => "controlleraction_index", :unique => false
    add_index :impressions, :user_id
  end

  def self.down
    remove_index :impressions, :name => :poly_index
    remove_index :impressions, :name => :controlleraction_index
    remove_index :impressions, :user_id
    
    drop_table :impressions
  end
end