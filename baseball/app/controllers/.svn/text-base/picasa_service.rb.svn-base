require 'feed_tools'

class PicasaService
  def self.get_photos(userid, albumid=nil, per_page=100, page=1)
    feed_url = PICASA_FEED_BASE_URL
    feed_url += "/user/#{userid}"
    feed_url += "/albumid/#{albumid}" unless albumid.blank?
    feed_url += "?kind=photo&max-results=#{per_page}&start-index=#{page}&imgmax=640&thumbsize=104u"

    begin
      feed = FeedTools::Feed.open(feed_url)
    rescue StandardError=>e
      raise "invalid_picasa_feed_url"
    end

    photo_feeds = []
    entries = feed.entries
    entries.each do |entry|
      photo_feed = PhotoFeed.new
      photo_feed.user_id = userid
      photo_feed.album_id = entry.find_node('gphoto:albumid/text()').value unless entry.find_node('gphoto:albumid/text()').nil?
      photo_feed.photo_id = entry.find_node('gphoto:id/text()').value
      photo_feed.title = entry.title
      photo_feed.description = entry.find_node('media:group/media:description/text()').value unless entry.find_node('media:group/media:description/text()').nil?
      photo_feed.photo_url = entry.find_node('media:group/media:content/@url').value
      photo_feed.thumbnail_url = entry.find_node('media:group/media:thumbnail/@url').value
      photo_feed.publish_date = Time.at(entry.find_node('gphoto:timestamp/text()').value.to_f/1000)
      photo_feeds << photo_feed
    end

    return photo_feeds
  end

  def self.get_albums(userid)
    feed_url = PICASA_FEED_BASE_URL
    feed_url += "/user/#{userid}"

    begin
      feed = FeedTools::Feed.open(feed_url)
    rescue StandardError=>e
      raise "invalid_picasa_feed_url"
    end

    photo_feeds = []
    entries = feed.entries
    entries.each do |entry|
      photo_feed = PhotoFeed.new
      photo_feed.user_id = userid
      photo_feed.album_id = entry.find_node('gphoto:id/text()').value
      photo_feed.title = entry.title
      photo_feed.description = entry.find_node('media:group/media:summary/text()').value unless entry.find_node('media:group/media:summary/text()').nil?
      photo_feed.photo_url = entry.find_node('id/text()').value
      photo_feed.thumbnail_url = entry.find_node('media:group/media:thumbnail/@url').value
      photo_feed.publish_date = DateTime.parse(entry.find_node('published/text()').value)
      photo_feeds << photo_feed
    end

    return photo_feeds
  end
end

