class AddExternalFlagToTeams < ActiveRecord::Migration
  def self.up
    add_column :teams, :is_external, :boolean, :default => false
  end

  def self.down
    remove_column :teams, :is_external
  end
end
