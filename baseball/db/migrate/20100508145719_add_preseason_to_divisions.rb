class AddPreseasonToDivisions < ActiveRecord::Migration
  def self.up
    add_column :divisions, :preseason_games, :integer, :default => 0
  end

  def self.down
    remove_column :divisions, :preseason_games
  end
end
