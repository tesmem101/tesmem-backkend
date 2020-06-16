require 'api_exception'

module SaveImage
  extend ActiveSupport::Concern

  included do
    helpers do

      def get_dimensions(image)
        image = MiniMagick::Image.open(request.base_url + image)
        return { height: image[:height], width: image[:width] }
      end
      def insert_image(design)
        dimension = get_dimensions(design.image.url(:thumb).to_s)
        Image.create(image: design, name: design.title, url: design.image.url(:thumb).to_s, height: dimension[:height].to_s, width: dimension[:width].to_s)
      end
      def update_image(design)
        dimension = get_dimensions(design.image.url(:thumb).to_s)
        currentImage = design.images().first
        Image.where(image: design).update(name: design.title, url: design.image.url(:thumb).to_s, height: dimension[:height].to_s, width: dimension[:width].to_s, version: currentImage.version+1)
      end
      
    end
  end
end
