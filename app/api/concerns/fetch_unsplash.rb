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
      def all_unsplash(search, page_number=1)
        if search
          return Unsplash::Photo.search(search, page = page_number, per_page = 30, orientation = nil)
        else
          return Unsplash::Photo.all(page = page_number, per_page = 30, order_by = "latest")
        end
      end
      def get_unsplash_response(unsplash_images)
        return {
          unsplash: unsplash_images,
          total_images: unsplash_images.length(),
          per_page: 90
        }
      end
    end
  end
end
