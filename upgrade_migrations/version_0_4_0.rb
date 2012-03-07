class Version04UpdateImpressionsTable < ActiveRecord::Migration
  def self.up
    add_column :impressions, :referrer, :string
  end

  def self.down
    remove_column :impressions, :referrer
  end
end
