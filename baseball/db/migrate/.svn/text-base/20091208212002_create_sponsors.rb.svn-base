class CreateSponsors < ActiveRecord::Migration
  def self.up
    create_table :sponsors do |t|
      t.string :company_name, :null => false
      t.string :company_website
      t.string :contact_name
      t.string :contact_email
      t.string :contact_phone
      t.string :street_address
      t.string :city
      t.string :state, :limit => 8
      t.string :zip_code, :limit => 12

      t.string :banner1_file_name
      t.string :banner1_content_type
      t.integer :banner1_file_size
      t.datetime :banner1_updated_at

      t.string :banner2_file_name
      t.string :banner2_content_type
      t.integer :banner2_file_size
      t.datetime :banner2_updated_at
      
      t.timestamps
    end

    create_table :sponsorships do |t|
      t.string  :sponsorable_type
      t.integer :sponsorable_id
      t.integer :sponsor_id
      t.date    :starts_at
      t.date    :ends_at
      t.string  :status
      t.string  :notes, :limit => 1024
      t.timestamps
    end
  end

  def self.down
    drop_table :sponsorships
    drop_table :sponsors
  end
end
