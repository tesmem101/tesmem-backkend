require 'api_exception'

module FetchPixabay
    extend ActiveSupport::Concern
    included do
      helpers do

        def map_pixabay_images(photo)
            return {
                id: photo['id'], 
                image: {
                    url:photo['imageURL'],
                    height: photo['imageHeight'], 
                    width: photo['imageWidth'],
                    thumb: photo['webformatURL']
                },
                artist: {
                    name: "By #{photo['user']}",
                    url: photo['pageURL']
                },
                source: {
                    name: 'Photo via Pixabay',
                    url: photo['pageURL']
                }
            }
        end

        def get_pixabay_response(pixabay_images)
            return {
                pixabay: pixabay_images,
                total_images: pixabay_images.length(),
                per_page: pixabay_images.length()
            }
        end

      end
    end
end