class CirclesMessage < ActiveRecord::Base
  belongs_to :contact
  has_many :mailbox_messages
  has_many :mailboxes, :through => :mailbox_messages
  
  acts_as_tree :foreign_key => "in_reply_to", :order => "sent DESC"
  
  # Instance Methods
  def add_reply(message_reply, contact)
    rp = CirclesMessage.new
    rp.subject = "Re: " + self.subject
    rp.body = message_reply
    rp.sent = Time.now
    rp.contact = contact
    rp.parent = self
    rp.save!
    rp
  end
  
  def unread(contact)
    contact_mailbox = mailboxes.find_by_contact_id(contact.id)
    mailbox_messages.find_by_mailbox_id(contact_mailbox.id).unread
  end 
  
  def mark_as_read(contact)
    contact_mailbox = mailboxes.find_by_contact_id(contact.id)
    MailboxMessage.update_all("unread = 0", "mailbox_id = #{contact_mailbox.id} AND circles_message_id = #{self.id}")
  end
  
  # Class Methods
  def self.create_from_params(params, contact)
    cm = CirclesMessage.new
    cm.subject = params[:subject]
    cm.body = params[:body]
    cm.sent = Time.now
    cm.important = params[:important]
    cm.contact = contact
    cm.save!
    cm
  end
  
end