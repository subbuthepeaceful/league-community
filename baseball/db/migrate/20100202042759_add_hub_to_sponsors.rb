class AddHubToSponsors < ActiveRecord::Migration
  def self.up
    add_column :sponsors, :hub_id, :integer
  end

  def self.down
    remove_column :sponsors
  end
end
