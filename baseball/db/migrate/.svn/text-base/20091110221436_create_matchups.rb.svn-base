class CreateMatchups < ActiveRecord::Migration
  def self.up
    create_table :matchups do |t|
      t.column :game_id, :integer, :null => false
      t.column :team_id, :integer, :null => false
      t.column :home_or_away, :string
    end
  end

  def self.down
    drop_table :matchups
  end
end
