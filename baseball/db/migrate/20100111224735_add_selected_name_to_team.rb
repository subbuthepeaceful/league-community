class AddSelectedNameToTeam < ActiveRecord::Migration
  def self.up
    add_column :teams, :selected_name, :string
  end

  def self.down
    remove_column :teams, :selected_name
  end
end
