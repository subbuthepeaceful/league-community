module FlickrFuExtensions

  module PhotosetsExtensions

    def self.included( recipient )
      recipient.extend( ClassMethods )
    end

    module ClassMethods
      def photosets_extensions
        include FlickrFuExtensions::PhotosetsExtensions::InstanceMethods
      end
    end

    module InstanceMethods
      def find_by_id(photoset_id)
        options = {:photoset_id =>photoset_id}
        rsp = @flickr.send_request('flickr.photosets.getInfo', options)
        photoset = nil
        if rsp && rsp.photoset
          attributes = create_attributes(rsp.photoset)
          photoset = Flickr::Photosets::Photoset.new(@flickr, attributes)
        end
        return photoset
      end

    end

  end

  module PhotosetExtensions
    def self.included( recipient )
      recipient.extend( ClassMethods )
    end

    module ClassMethods
      def photoset_extensions
        include FlickrFuExtensions::PhotosetExtensions::InstanceMethods
      end
    end

    module InstanceMethods
      def get_photos2(options={})
        options = options.merge(:photoset_id=>id, :extras => "license,date_upload,date_taken,owner_name,icon_server,original_format,last_update,geo,tags,machine_tags,o_dims,views,media")
        rsp = @flickr.send_request('flickr.photosets.getPhotos', options)
        collect_photos2(rsp)
      end

        def collect_photos2(rsp)
          photos = []
          return photos unless rsp
          if rsp.photoset.photo
            rsp.photoset.photo.each do |photo|
              attributes = create_attributes2(photo)
              photos << Flickr::Photos::Photo.new(@flickr,attributes)
            end
          end
          return photos
        end

        def create_attributes2(photo)
          {:id => photo[:id],
           :secret => photo[:secret],
           :server => photo[:server],
           :farm => photo[:farm],
           :title => photo[:title],
            :license_id => photo[:license].to_i,
            :uploaded_at => (Time.at(photo[:dateupload].to_i) rescue nil),
            :taken_at => (Time.parse(photo[:datetaken]) rescue nil),
            :owner_name => photo[:ownername],
            :icon_server => photo[:icon_server],
            :original_format => photo[:originalformat],
            :updated_at => (Time.at(photo[:lastupdate].to_i) rescue nil),
            :geo => photo[:geo],
            :tags => photo[:tags],
            :machine_tags => photo[:machine_tags],
            :o_dims => photo[:o_dims],
            :views => photo[:views].to_i,
            :media => photo[:media]}
        end
    end
  end
end
