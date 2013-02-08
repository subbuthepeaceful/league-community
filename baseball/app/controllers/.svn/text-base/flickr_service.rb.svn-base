require 'flickr_fu'
class FlickrService
  #get a flickr object
  @@flickr = Flickr.new("#{RAILS_ROOT}/config/flickr.yml")

  def self.get_photos(flickr_id, albumid=nil, per_page=100, page=1)
    if albumid.blank?
      get_public_photos(flickr_id, per_page, page)
    else
      get_album_photos(flickr_id, albumid, per_page, page)
    end
  end

  def self.get_public_photos(flickr_id, per_page=100, page=1)
    begin
      begin
        person = get_person(flickr_id)
      rescue Exception=>e
        raise "flickr_user_not_found"
      end
      photo_rsp = person.public_photos(:per_page => per_page, :page => page)
    rescue StandardError=>e
      puts e.backtrace.join("\n");
      raise "flickr_photos_not_found"
    end

    photo_feeds = retrieve_photos(photo_rsp.photos, flickr_id)
    return photo_feeds
  end

  def self.get_album_photos(flickr_id, albumid, per_page=100, page=1)
    begin
      photoset = @@flickr.photosets.find_by_id(albumid)
      photos = photoset.get_photos2
    rescue Exception=>e
      raise "flickr_album_not_found"
    end

    photo_feeds = retrieve_photos(photos, flickr_id)
    return photo_feeds
  end

  def self.get_albums(flickr_id)
    begin
      begin
        person = get_person(flickr_id)
      rescue StandardError=>e
        raise "flickr_user_not_found"
      end
      photosets = @@flickr.photosets.get_list(:user_id=>person.nsid)
    rescue Exception=>e
      raise "flickr_albums_not_found"
    end

    photo_feeds = []
    photosets.each do |photoset|
      photo_feed = PhotoFeed.new
      photo_feed.user_id = flickr_id
      photo_feed.album_id = photoset.id
      photo_feed.title = photoset.title
      photo_feed.description = photoset.description

      if photoset.num_photos.to_i > 0
        set_photos = photoset.get_photos(:per_page=>1)
        if set_photos && !set_photos.empty?
          photo_feed.thumbnail_url = set_photos[0].url(:thumbnail)
        end
      end
      
      photo_feeds << photo_feed
    end

    return photo_feeds
  end

  def self.get_person(flickr_id)
    begin
      person = @@flickr.people.find_by_username(flickr_id)
    rescue StandardError=>e
      # try with findByEmail
      begin
        person = @@flickr.people.find_by_email(flickr_id)
      rescue StandardError=>e
        raise "flickr_user_not_found"
      end
    end
  end

  protected
  def self.retrieve_photos(photos, flickr_id)
    photo_feeds = []
    photos.each do |fp|
      photo_feed = PhotoFeed.new
      photo_feed.user_id = flickr_id
      photo_feed.photo_id = fp.id
      photo_feed.title = fp.title
      photo_feed.description = fp.description
      photo_feed.publish_date = fp.taken_at
      photo_feed.photo_url = fp.url(:medium) #photo_image_url(fp)
      photo_feed.thumbnail_url = fp.url(:thumbnail)
      photo_feeds << photo_feed
    end

    return photo_feeds
  end

  #for optimization - each  flikcr_fu's photo.url call sends a request to the flickr site to retrive the photo info.
  #This method would avoid that call.
  def self.photo_image_url(photo)
    return 'http://farm'+photo.farm+'.static.flickr.com/'+photo.server+'/'+photo.id+'_'+photo.secret + '_s.jpg'
  end
end
