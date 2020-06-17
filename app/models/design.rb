class Design < ApplicationRecord
  belongs_to :user
  mount_uploader :image, ImageUploader
  has_many :images, as: :image, dependent: :destroy
end
