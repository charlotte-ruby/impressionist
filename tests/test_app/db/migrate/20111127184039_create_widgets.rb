class CreateWidgets < ActiveRecord::Migration[4.2]
  def self.up
    create_table :widgets do |t|
      t.string :name
      t.integer :impressions_count, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :widgets
  end
end

