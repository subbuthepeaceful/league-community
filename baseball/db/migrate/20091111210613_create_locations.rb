class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.column :hub_id, :integer, :null => false
      t.column :name, :string, :null => false
      t.column :street_address, :string
      t.column :city, :string
      t.column :state, :string, :limit => 8
      t.column :zip_code, :string, :limit => 12
      t.column :comments, :text
    end
  end

  def self.down
    drop_table :locations
  end
end
