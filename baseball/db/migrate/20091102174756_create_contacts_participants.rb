class CreateContactsParticipants < ActiveRecord::Migration
  def self.up
    create_table :contacts_participants, :id => false do |t|
      t.column :contact_id, :integer
      t.column :participant_id, :integer
    end
  end

  def self.down
    drop_table :contacts_participants
  end
end
