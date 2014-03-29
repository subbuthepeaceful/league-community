class CreateFields < ActiveRecord::Migration
  def up
    create_table :fields do |t|
      t.string :name, :null => false
      t.string :location
      t.string :address, :null => false
      t.text :instructions
    end
  end

  def down
    drop_table :fields
  end
end
