class Stock < ApplicationRecord
  attribute :title
  attribute :description
  attribute :path
  attribute :category_id

  mount_uploaders :images, ImageUploader
end
