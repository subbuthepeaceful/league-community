class CreateTeamMemberships < ActiveRecord::Migration
  def self.up
    create_table :team_memberships do |t|
      t.column :participant_id, :integer, :null => false
      t.column :team_id, :integer, :null => false
      t.column :role, :string
    end
  end

  def self.down
    drop_table :team_memberships
  end
end
