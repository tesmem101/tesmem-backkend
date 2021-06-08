require 'api_exception'

module FetchPexel
    extend ActiveSupport::Concern
    included do
      helpers do

        def get_pexel_images(search = nil, page_number = 1, page_size = 30)
            if search
                return Pexel.photos.search(search, page: page_number, per_page: page_size)
            else
                return Pexel.photos.curated(page: page_number, per_page: page_size)
            end
        end

        def map_pexel_images(photo)
            return {
                id: photo.id, 
                image: {
                    url:photo.src['original'],
                    height: photo.height, 
                    width: photo.width
                },
                artist: {
                    name: "By #{photo.user.name}",
                    url: photo.user.url
                },
                source: {
                    name: 'Photo via Pexels',
                    url: photo.url
                }
            }
        end

        def get_pexel_response(pexel_images)
            return {
                pexels: pexel_images,
                total_images: pexel_images.length(),
                per_page: pexel_images.length()
            }
        end

      end
    end
end