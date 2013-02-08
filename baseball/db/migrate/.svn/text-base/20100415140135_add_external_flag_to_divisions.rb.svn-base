class AddExternalFlagToDivisions < ActiveRecord::Migration
  def self.up
    add_column :divisions, :external, :boolean, :default => false
  end

  def self.down
    remove_column :divisions
  end
end
