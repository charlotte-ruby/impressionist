class Version152UpdateImpressionsTable < ActiveRecord::Migration
  def self.up
    add_column :impressions, :params, :text

    add_index :impressions, [:impressionable_type, :impressionable_id, :params], :name => "poly_params_request_index", :unique => false
  end

  def self.down
    remove_index :impressions, [:impressionable_type, :impressionable_id, :params], :name => "poly_params_request_index"
    remove_column :impressions, :params
  end
end