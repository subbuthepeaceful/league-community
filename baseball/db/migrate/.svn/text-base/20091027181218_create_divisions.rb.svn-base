class CreateDivisions < ActiveRecord::Migration
  def self.up
    create_table :divisions do |t|
      t.column :name, :string
      t.column :age_range, :string
      t.column :program_id, :integer, :null => false
      t.column :description, :text
      t.column :team_prefix, :string
    end
  end

  def self.down
    drop_table :divisions
  end
end
