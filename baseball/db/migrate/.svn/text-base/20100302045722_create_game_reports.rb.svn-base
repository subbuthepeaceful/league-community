class CreateGameReports < ActiveRecord::Migration
  def self.up
    create_table :game_reports do |t|
      t.column :contact_id, :integer, :null => false
      t.column :team_id, :integer, :null => false
      t.column :game_id, :integer, :null => false
      t.column :actual_start_date, :datetime
      t.column :actual_start_time, :datetime
      t.column :actual_end_time, :datetime
      t.column :home_team_score, :integer
      t.column :away_team_score, :integer
      t.column :num_innings_played, :integer
      t.column :end_reason, :string
      t.column :plate_umpire, :string
      t.column :field_umpire, :string
      t.column :comments, :text
      t.timestamps
    end
  end

  def self.down
    drop_table :game_reports
  end
end
