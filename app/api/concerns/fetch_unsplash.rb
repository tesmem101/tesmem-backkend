require 'api_exception'

module FetchUnsplash
  extend ActiveSupport::Concern
  included do
    helpers do
      def map_unsplash_images(photo)
          return {
            id: photo.id, 
            title: photo.description, 
            image: {
              url:photo.urls.small,
              height: photo.height, 
              width: photo.width
            },
            artist: {
              name: "By #{photo.user.name}",
              url: photo.user.links.html
            },
            source: {
              name: 'Photo via Unsplash',
              url: photo.links.html
            }
          }
      end
      def all_unsplash(search)
        if search
          return Unsplash::Photo.search(search, page = 1, per_page = 50, orientation = nil)
        else
          return Unsplash::Photo.all(page = 1, per_page = 50, order_by = "latest")
        end
      end
    end
  end
end
