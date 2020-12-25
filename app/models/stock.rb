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

    if self.svg.present? # ALSO CHECK IF THIS ATTR CHANGED
      if Rails.env.development?
        url = "#{ENV["HOST_URL"]}#{self.svg}"
      else
        url = "#{self.svg}"
      end
      # puts "=============================================="
      # puts "SELECTED_URL: #{url}"
      # puts "HOST_URL: #{ENV["HOST_URL"]}"
      # puts "SVG: #{self.svg}"
      # puts "SVG Path: #{self.svg.file.path}"
      doc = Nokogiri::HTML open(url)
      svg = doc.at_css 'svg'
      count = 1
      colors = []
      title = self.title
      title.gsub! ' ', '_'
      svg.xpath('//path').each{|tag| 
        tag['fill'] = "#000000" if tag['fill'].blank? || tag['fill'] === "none"
        tag['id'] = "#{title}_#{self.sub_category.title}_#{count}"
        tag['class'] = "#{title}_#{self.sub_category.title}_#{tag['fill']}"
        count = count + 1
        colors.push({ id: tag['id'], color: tag['fill'], class: tag['class'] })
        colors.uniq { |row| [row['color']] }
      }
      self.specs = colors
      self.description = svg
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

  def self.search_keyword(locale = '', keyword)
    where("lower(stocks.title#{locale}) LIKE ?", "%#{keyword}%")
  end
end
