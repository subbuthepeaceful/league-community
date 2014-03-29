class CreateTeams < ActiveRecord::Migration
  def up
    create_table :teams do |t|
      t.string :name, :null => false
      t.string :gender
      t.integer :age_group_id, :null => false
    end
  end

  def down
    drop_table :teams
  end
end
