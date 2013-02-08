class CreateAvailabilities < ActiveRecord::Migration
  def self.up
    create_table :availabilities do |t|
      t.column :game_id, :integer, :null => false
      t.column :participant_id, :integer, :null => false
      t.column :available, :boolean
      t.timestamps
    end
  end
  
  def self.down
    drop_table :availabilities
  end
end