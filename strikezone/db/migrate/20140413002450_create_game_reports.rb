class CreateGameReports < ActiveRecord::Migration
  def up
    create_table :game_reports do |t|
      t.integer :game_id, :null => false
      t.integer :user_id, :null => false
      t.string :home_or_away
      t.integer :home_team_score
      t.integer :away_team_score
      t.text :comments
    end
  end

  def down
    drop_table :game_reports
  end
end
