class AddLocationToGames < ActiveRecord::Migration
  def self.up
    add_column :games, :location_id, :integer
  end

  def self.down
    remove_column :games, :location_id
  end
end
