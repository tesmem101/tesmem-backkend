module ActiveAdmin
    module SaveImage

        def get_dimensions(url)
            url = "#{ENV["HOST_URL"]}#{url}" if Rails.env.development?
            image = MiniMagick::Image.open(url)
            return { height: image[:height], width: image[:width] }
        end

        def insert_image(imageObject)
            dimension = get_dimensions(imageObject.image.url(:thumb).to_s)
            Image.create(image: imageObject, name: imageObject.title, url: imageObject.image.url(:thumb).to_s, height: dimension[:height].to_s, width: dimension[:width].to_s)
        end

        def update_image(imageObject)
            dimension = get_dimensions(imageObject.image.url(:thumb).to_s)
            currentImage = imageObject.images().first
            Image.where(image: imageObject).update(name: imageObject.title, url: imageObject.image.url(:thumb).to_s, height: dimension[:height].to_s, width: dimension[:width].to_s, version: currentImage.version+1)
        end
    end
end