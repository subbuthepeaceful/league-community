class Photo < ActiveRecord::Base
  belongs_to :participant
  belongs_to :team

  has_attached_file :image, :styles => { :thumb => "100x80>", :large => "640x480>" }

  def image_url
    source.blank? ? image.url(:large) : photo_url
  end

  def image_thumb_url
    source.blank? ? image.url(:thumb) : thumbnail_url
  end
  
  def self.paticipant_photos(paticipant, provider = nil)
    if provider
      paticipant.photos.find(:all,
                              :conditions => {:source => provider.name, :paticipant_id => paticipant.id},
                              :order => 'created_at desc')
    else
      paticipant.photos
    end
  end

  def self.team_photos(team, limit=100)
    Photo.find(:all,
                :conditions => {:team_id => team.id},
                :order => 'created_at desc',
                :limit => limit)
  end

  def self.team_other_photos(team, participant)
    Photo.find(:all,
                :conditions => ['team_id = ? and participant_id <> ?', team.id, participant.id],
                :order => 'created_at desc')
  end

  def self.create_participant_photo(user, participant, provider, photo_feed)
    Photo.create(:user_id => user.id,
                 :participant_id => participant.id,
                 :team_id => participant.team.id,
                 :source => provider.name,
                 :source_user_id => provider.user_id,
                 :source_photo_id => photo_feed.photo_id,
                 :title => photo_feed.title,
                 :description => photo_feed.description,
                 :thumbnail_url => photo_feed.thumbnail_url,
                 :photo_url => photo_feed.photo_url,
                 :publish_date => photo_feed.publish_date)
  end

  def self.delete_participant_photo(user, participant, photo_id)
    photo = Photo.find(:first, :conditions => {:user_id => user.id,
                                     :participant_id => participant.id,
                                     :id => photo_id})
    if photo
      photo.destroy
    end    
  end
end