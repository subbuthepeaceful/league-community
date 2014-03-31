class CreatePlayers < ActiveRecord::Migration
  def up
    create_table :players do |t|
      t.integer :team_id
      t.string :first_name, :null => false
      t.string :last_name, :null => false
      t.string :jersey_number
    end
  end

  def down
    drop_table :players
  end
end
