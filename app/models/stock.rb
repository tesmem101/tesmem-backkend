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
      # puts "SVG Path: #{self.svg.file.path}"
      doc = Nokogiri::HTML open(url)
      svg = doc.at_css 'svg'
      title = self.title
      title.gsub! ' ', '_'

      count = 1
      colors_arr = []
      specs_arr = []
      svg.xpath('//g').each do |g_tag|
          g_tag.children.each do |tag|
            next if tag.name == "g"
            tag['fill'] = "#000000" if tag['fill'].blank? || tag['fill'] === "none"
            tag['id'] = "#{title}_#{self.sub_category.title}_#{count}"
            tag['class'] = "#{title}_#{self.sub_category.title}_#{tag['fill']}"
            count = count + 1
            # Making Specs Array
            if tag.attributes['fill'].present? && 
                tag.attributes['fill'].value !='none' &&
              !(colors_arr.include? tag.attributes['fill'].value)
              colors_arr << tag.attributes['fill'].value
              specs_arr << { id: tag['id'], color: tag.attributes['fill'].value, class: tag['class'] }
            end
          end
      end

      # Previous implementation
      # svg.xpath('//path').each{|tag| 
      #   tag['fill'] = "#000000" if tag['fill'].blank? || tag['fill'] === "none"
      #   tag['id'] = "#{title}_#{self.sub_category.title}_#{count}"
      #   tag['class'] = "#{title}_#{self.sub_category.title}_#{tag['fill']}"
      #   count = count + 1
      #   # unless colors_arr.include? tag['fill']
      #   #   colors_arr << tag['fill']
      #   #   specs_arr << { id: tag['id'], color: tag['fill'], class: tag['class'] }
      #   # end
      # }

      self.description = svg
      self.specs = specs_arr
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
