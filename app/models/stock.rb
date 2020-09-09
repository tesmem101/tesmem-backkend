class Stock < ApplicationRecord
  include CarrierWave::MiniMagick
  
  belongs_to :category
  belongs_to :sub_category

  enum stocktype: [:image, :svg]

  mount_uploader :image, StockUploader
  mount_uploader :svg, SvgUploader
  
  after_find :mapping_image_url
  after_save :update_url

  def mapping_image_url
    if self.image.present?
      self.url = self.image.url
    end
    if self.svg.present?
      self.url = self.svg.url
    end
  end
  def update_url
    if self.image.present?
      self.url = self.image.url
    end
  end
end
