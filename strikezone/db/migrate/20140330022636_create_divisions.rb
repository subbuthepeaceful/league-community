class CreateDivisions < ActiveRecord::Migration
  def up
    create_table :divisions do |t|
      t.string :name
    end
  end

  def down
    drop_table :divisions
  end
end
