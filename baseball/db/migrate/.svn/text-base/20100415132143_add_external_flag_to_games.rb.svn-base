class AddExternalFlagToGames < ActiveRecord::Migration
  def self.up
    add_column :games, :external, :boolean, :default => false
  end

  def self.down
    remove_column :games
  end
end
