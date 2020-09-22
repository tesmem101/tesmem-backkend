class Category < ApplicationRecord
  has_many :sub_categories, dependent: :destroy
  has_many :stocks, dependent: :destroy
  has_many :designers, dependent: :destroy

  has_many   :intermediate_categories, class_name: "Category", foreign_key: "super_category_id", dependent: :destroy
  belongs_to :super_category,     class_name: "Category", optional: true

  mount_uploader :cover, CoverUploader
  has_one :image, as: :image, dependent: :destroy
  after_save :add_cover_photo

  def add_cover_photo
    if self.cover.present? && self.cover.thumb.url.present?
      current_image = self.cover.thumb.url
      img = MiniMagick::Image::open(current_image)
      height = img[:height].to_s
      width = img[:width].to_s
      title = self.title
      if Image.where(image: self).present?
        Image.where(image: self).update(name: title, url: self.cover.thumb.url, height: height, width: width)
      else
        Image.create(image: self, name: title, url: self.cover.thumb.url, height: height, width: width)
      end
    end
  end  
end
