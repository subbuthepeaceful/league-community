class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.column :street_address, :string
      t.column :city, :string
      t.column :state, :string, :limit => 8
      t.column :zip_code, :string, :limit => 12
      t.column :contact_id, :integer
    end
  end

  def self.down
    drop_table :addresses
  end
end
