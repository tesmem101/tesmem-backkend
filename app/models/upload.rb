class Upload < ApplicationRecord
  belongs_to :user
  mount_uploader :image, ImageUploader
  has_many :images, as: :image, dependent: :destroy
  has_one :container, as: :instance, dependent: :destroy
end
