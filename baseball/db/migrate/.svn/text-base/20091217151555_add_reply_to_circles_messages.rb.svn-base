class AddReplyToCirclesMessages < ActiveRecord::Migration
  def self.up
    add_column :circles_messages, :in_reply_to, :integer
  end

  def self.down
    remove_column :circles_messages, :in_reply_to
  end
end
