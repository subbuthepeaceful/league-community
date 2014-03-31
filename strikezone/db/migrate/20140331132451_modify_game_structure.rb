class ModifyGameStructure < ActiveRecord::Migration
  def up
    remove_column :games, :team_id
    remove_column :games, :external_id
    remove_column :games, :game_slot_id
    remove_column :games, :opponent
    remove_column :games, :is_home_game

    add_column :games, :home_team_id, :integer
    add_column :games, :away_team_id, :integer

  end

  def down

    remove_column :games, :away_team_id
    remove_column :games, :home_team_id

    add_column :games, :team_id, :integer
    add_column :games, :external_id, :integer
    add_column :games, :game_slot_id, :integer
    add_column :games, :opponent, :string
    add_column :games, :is_home_game, :boolean

  end
end
