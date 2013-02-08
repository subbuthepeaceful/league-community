class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.integer :user_id
      t.integer :participant_id
      t.integer :team_id
      t.string  :source
      t.string  :source_user_id
      t.string  :source_album_id
      t.string  :source_photo_id
      t.string  :title
      t.string  :description, :limit => 1024
      t.string  :thumbnail_url, :limit => 512
      t.string  :photo_url, :limit => 512
      t.timestamp :publish_date
      t.timestamps
    end
  end

  def self.down
    drop_table :photos
  end
end
