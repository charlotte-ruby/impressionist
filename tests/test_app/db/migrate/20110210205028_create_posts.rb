class CreatePosts < ActiveRecord::Migration<%= Rails::VERSION::MAJOR >= 5 ? "[#{Rails.version.to_f}]" : "" %>
  def self.up
    create_table :posts do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
