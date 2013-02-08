class CreateTeamRecords < ActiveRecord::Migration
  def self.up
    create_table :team_records do |t|
      t.column :team_id, :integer, :null => false
      t.column :games_played, :integer, :default => 0
      t.column :wins, :integer, :default => 0
      t.column :losses, :integer, :default => 0
      t.column :ties, :integer, :default => 0
      t.column :win_pct, :float, :default => 0
      t.column :runs_for, :integer, :default => 0
      t.column :runs_against, :integer, :default => 0
    end
  end

  def self.down
    drop_table :team_records
  end
end
