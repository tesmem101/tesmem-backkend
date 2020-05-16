class Stock < ApplicationRecord
  belongs_to :category
  belongs_to :sub_category

  mount_uploaders :images, ImageUploader
end
