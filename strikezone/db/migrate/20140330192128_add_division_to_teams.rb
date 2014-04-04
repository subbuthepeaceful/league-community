class AddDivisionToTeams < ActiveRecord::Migration
  def up
    add_column :teams, :division_id, :integer, :null => false

    remove_column :teams, :age_group_id
  end

  def down
    add_column :teams, :age_group_id, :integer, :null => false

    remove_column :teams, :division_id
  end
end
