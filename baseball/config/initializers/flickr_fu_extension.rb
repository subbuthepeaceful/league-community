Flickr::Photosets.class_eval do
  Flickr::Photosets.send(:include, FlickrFuExtensions::PhotosetsExtensions)
  photosets_extensions
end

Flickr::Photosets::Photoset.class_eval do
  Flickr::Photosets::Photoset.send(:include, FlickrFuExtensions::PhotosetExtensions)
  photoset_extensions
end
