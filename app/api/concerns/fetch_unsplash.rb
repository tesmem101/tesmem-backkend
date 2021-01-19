require 'api_exception'

module FetchUnsplash
  extend ActiveSupport::Concern
  included do
    helpers do
      def map_unsplash_images(photo, size)

          return {
            id: photo.id, 
            title: photo.description, 
            image: {
              url:photo.urls[size],
              height: photo.height, 
              width: photo.width
            },
            artist: {
              name: "By #{photo.user.name}",
              url: photo.user.links.html
            },
            source: {
              name: 'Photo via Unsplash',
              url: photo.links.html,
              download_Url: photo.links.download_location
            }
          
          }
      end
      def map_unsplash_backgrounds(photo, size)
        return {
          id: photo.id, 
          title: photo.description, 
          url:photo.urls[size]
        }
    end
      def get_unsplash_response(unsplash_images)
        return {
          unsplash: unsplash_images,
          total_images: unsplash_images.length(),
          per_page: unsplash_images.length()
        }
      end
      def get_unsplash_images(search, page_number=1, orientation=nil, page_size=30, order_by='latest')
        if search
          return Unsplash::Photo.search(search, page = page_number, per_page = page_size, orientation = orientation)
        else
          return Unsplash::Photo.all(page = page_number, per_page = page_size, order_by = order_by)
        end
      end
      def track_unsplash_download(id)
        puts(id.class)
        puts(123.class)
        photo = Unsplash::Photo.find(id)
        return photo.track_download
      end
    end
  end
end
