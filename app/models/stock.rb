class Stock < ApplicationRecord
  include CarrierWave::MiniMagick
  
  belongs_to :category
  belongs_to :sub_category

  mount_uploader :image, StockUploader
  
  after_find :mapping_image_url
  before_save :update_dimensions
  after_save :update_url

  def update_dimensions 
    if self.image.present?
      current_image = "#{ENV["RAIL_SERVER_URL"]}#{self.image}"
      img = MiniMagick::Image::open(current_image)
      height = img[:height].to_s
      width = img[:width].to_s
      self.size = "#{height} x #{width} px"
      self.stocktype = self.title
      self.height = height
      self.width = width
    end 
  end
  def mapping_image_url
    if self.image.present?
      self.url = self.image.url
    end
  end
  def update_url
    if self.image.present?
      self.url = self.image.url
    end
  end
end
