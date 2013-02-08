class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      t.column :title, :string, :limit => 8
      t.column :first_name, :string, :limit => 24
      t.column :last_name, :string, :limit => 24
      t.column :email_address, :string, :limit => 64
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :contacts
  end
end
