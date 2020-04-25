class CreateProfiles < ActiveRecord::Migration[4.2]
  def change
    create_table :profiles do |t|
      t.string :username
      t.string :slug

      t.timestamps
    end
  end
end
