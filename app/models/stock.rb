class Stock < ApplicationRecord
  belongs_to :category
  
  mount_uploaders :image, ImageUploader
end
