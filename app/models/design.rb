class Design < ApplicationRecord
  include DesignAdmin

  attr_accessor :folder_id

  belongs_to :user
  mount_uploader :image, ImageUploader
  has_many :images, as: :image, dependent: :destroy
  has_one :container, as: :instance, dependent: :destroy
  has_one :designer, dependent: :destroy
  has_many :templates, class_name: "Designer", foreign_key: "design_id",  dependent: :destroy
end
