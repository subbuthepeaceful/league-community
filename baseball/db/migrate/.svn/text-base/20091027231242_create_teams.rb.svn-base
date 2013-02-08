class CreateTeams < ActiveRecord::Migration
  def self.up
    create_table :teams do |t|
      t.column :name, :string
      t.column :division_id, :integer
      t.column :session_id, :integer
    end
  end

  def self.down
    drop_table :teams
  end
end
