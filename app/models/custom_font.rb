class CustomFont < ApplicationRecord
  mount_uploader :file, CustomFontUploader
  validates_presence_of :name
  belongs_to :user
end
