class AddAdminContact < ActiveRecord::Migration
  def self.up
    a = User.find_by_login('admin')
    c = Contact.new
    c.first_name = "System"
    c.last_name = "Administrator"
    c.email_address = "admin@strongcircles.com"
    c.user = a
    c.save!
    
    mbox = Mailbox.new
    mbox.contact = c
    mbox.save
  end

  def self.down
    c = Contact.find_by_first_name("System")
    c.delete
  end
end
