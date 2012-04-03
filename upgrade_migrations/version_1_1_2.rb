class Version04UpdateImpressionsTable < ActiveRecord::Migration
  def self.up
    add_index :impressions, [:impressionable_type, :message, :impressionable_id], :name => "impressionable_type_message_index", :unique => false
  end

  def self.down
    remove_index :impressions, :impressionable_type_message_index
  end
end
