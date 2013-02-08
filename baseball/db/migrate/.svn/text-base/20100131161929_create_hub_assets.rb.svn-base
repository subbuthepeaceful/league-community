class CreateHubAssets < ActiveRecord::Migration
  def self.up
    create_table :hub_assets do |t|
      t.column :hub_id, :integer, :null => false
      t.column :name, :string
      t.column :uri, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :hub_assets
  end
end
