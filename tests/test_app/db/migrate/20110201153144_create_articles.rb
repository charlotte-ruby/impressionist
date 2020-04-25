class CreateArticles < ActiveRecord::Migration[4.2]
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
