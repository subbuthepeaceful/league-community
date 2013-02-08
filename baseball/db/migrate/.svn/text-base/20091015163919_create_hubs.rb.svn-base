class CreateHubs < ActiveRecord::Migration
  def self.up
    create_table :hubs do |t|
      t.column :name, :string, :null => false
      t.column :url_prefix, :string, :null => false
      t.column :description, :text
      t.column :parent_id, :integer
      t.column :time_zone, :string, :default => 'UTC'
      t.column :active_since, :datetime
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :hubs
  end
end
