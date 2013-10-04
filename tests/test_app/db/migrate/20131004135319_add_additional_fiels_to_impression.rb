class AddAdditionalFielsToImpression < ActiveRecord::Migration
  def change
    add_column :impressions, :article_name, :string
  end
end
