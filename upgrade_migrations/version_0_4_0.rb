class Version04UpdateImpressionsTable < ActiveRecord::Migration<%= Rails::VERSION::MAJOR >= 5 ? "[#{Rails.version.to_f}]" : "" %>
  def self.up
    add_column :impressions, :referrer, :string
  end

  def self.down
    remove_column :impressions, :referrer
  end
end
