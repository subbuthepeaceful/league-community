class AddHomeUrlToHubs < ActiveRecord::Migration
  def self.up
    add_column :hubs, :home_url, :string
  end

  def self.down
    remove_column :hubs, :home_url
  end
end
