class CreateAgeGroupsFields < ActiveRecord::Migration
  def up
    create_table :age_groups_fields, :id => false do |t|
      t.integer :age_group_id, :null => false
      t.integer :field_id, :null => false
    end
  end

  def down
    drop_table :age_groups_fields
  end
end
