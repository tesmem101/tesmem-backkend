class CustomFont < ApplicationRecord
  mount_base64_uploader :file, CustomFontUploader
  validates_presence_of :name
  belongs_to :user
end
