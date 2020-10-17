class Stock < ApplicationRecord
  include CarrierWave::MiniMagick
  include Nokogiri
  
  belongs_to :category
  belongs_to :sub_category

  enum stocktype: [:image, :svg]

  mount_uploader :image, StockUploader
  mount_uploader :svg, SvgUploader
  
  after_find :mapping_image_url
  after_save :update_url
  before_save :add_ids_to_svg

  def add_ids_to_svg
    if self.svg.present?
      url = "#{ENV["RAIL_SERVER_URL"]}#{self.svg}"
      doc = Nokogiri::HTML open(url)
      svg = doc.at_css 'svg'
      count = 1
      colors = []
      svg.xpath('//path').each{|tag| 
          tag['id'] = "PATH_#{count}"
          count = count + 1
          colors.push({
            id: tag['id'],
            color: tag['fill']
          })
      }
      self.colors = colors.to_json
    end
  end

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
