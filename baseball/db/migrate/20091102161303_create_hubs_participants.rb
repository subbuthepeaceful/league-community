class CreateHubsParticipants < ActiveRecord::Migration
  def self.up
    create_table :hubs_participants, :id => false do |t|
      t.column :hub_id, :integer
      t.column :participant_id, :integer
    end
  end

  def self.down
    drop_table :hubs_participants
  end
end
