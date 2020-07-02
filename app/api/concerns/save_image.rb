require 'api_exception'

module SaveImage
  extend ActiveSupport::Concern

  included do
    helpers do

      def encode_image(title, image)
        regex = /\Adata:([-\w]+\/[-\w\+\.]+)?;base64,(.*)/m
        data_uri_parts = image.match(regex) || []
        image_data = Base64.decode64(data_uri_parts[2])
        extension = data_uri_parts[1].split('/')[1]
        form_data = File.new("#{title}.#{extension}", 'wb')
        form_data.write(image_data)
        return form_data
      end
      def get_dimensions(image)
        image = MiniMagick::Image.open(image)
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
