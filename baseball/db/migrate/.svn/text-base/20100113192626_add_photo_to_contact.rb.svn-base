class AddPhotoToContact < ActiveRecord::Migration
  def self.up
    add_column :contacts, :profile_photo_file_name, :string
    add_column :contacts, :profile_photo_content_tye, :string
    add_column :contacts, :profile_photo_file_size, :integer
  end

  def self.down
    remove_column :contacts, :profile_photo_file_name
    remove_column :contacts, :profile_photo_content_type
    remove_column :contacts, :profile_photo_file_size
  end
end
