class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.column :division_id, :integer, :null => false
      t.column :scheduled_at, :datetime
      t.column :notes, :text
      t.column :snack_volunteer_id, :integer
    end
  end

  def self.down
    drop_table :games
  end
end
