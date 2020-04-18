class CreateArticles < ActiveRecord::Migration<%= Rails::VERSION::MAJOR >= 5 ? "[#{Rails.version.to_f}]" : "" %>
  def self.up
    create_table :articles do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :articles
  end
end
