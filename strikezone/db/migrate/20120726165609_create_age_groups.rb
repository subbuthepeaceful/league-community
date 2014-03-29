class CreateAgeGroups < ActiveRecord::Migration
  def up
    create_table :age_groups do |t|
      t.string :name, :null => false
      t.string :team_size, :null => false
    end
  end

  def down
    drop_table :age_groups
  end
end
