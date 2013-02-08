class CreateMailboxMessages < ActiveRecord::Migration
  def self.up
    create_table :mailbox_messages, :id => false do |t|
      t.column :mailbox_id, :integer, :null => false
      t.column :circles_message_id, :integer, :null => false
      t.column :unread, :boolean, :default => true
    end
  end

  def self.down
    drop_table :mailbox_messages
  end
end
