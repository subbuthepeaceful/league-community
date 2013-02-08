class CreatePrograms < ActiveRecord::Migration
  def self.up
    create_table :programs do |t|
      t.column :hub_id, :integer, :null => false
      t.column :name, :string
      t.column :description, :text
      t.column :status, :string, :default => "Active"
      t.column :created_on, :datetime
      t.column :created_by, :string
      t.column :parent_id, :integer, :default => nil
    end
  end

  def self.down
    drop_table :programs
  end
end
