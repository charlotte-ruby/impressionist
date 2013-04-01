class AddParamsToImpressionsTable < ActiveRecord::Migration
  def change
    add_column :impressions, :params, :hstore
  end
end