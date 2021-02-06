class Stock < ApplicationRecord
  include CarrierWave::MiniMagick
  include Nokogiri
  include StockAdmin
  
  enum stocktype: [:image, :svg]

  mount_uploader :image, StockUploader
  mount_uploader :svg, SvgUploader
  mount_uploader :svg_thumb, SvgThumbUploader

  belongs_to :category
  belongs_to :sub_category
  has_many :stock_tags, dependent: :destroy
  has_many :tags, through: :stock_tags

  scope :icons_stock, -> { joins(:category).where(categories: {title: TITLES[:icon]}) }

  accepts_nested_attributes_for :stock_tags, :allow_destroy => true

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
      g_tags = svg.xpath('//g')
      if g_tags.present?
        g_tags.each do |g_tag|
            g_tag.children.each do |tag|
              next if tag.name == "g"
              fill_id_class(tag, title, count)
              make_specs_array(tag, colors_arr, specs_arr)
            end
        end
      else
        svg.xpath('//path').each do |g_tag|
          g_tag.children.each do |tag|
            fill_id_class(tag, title, count)
            make_specs_array(tag, colors_arr, specs_arr)
          end
        end
      end

      # V: 1.2
      # svg.xpath('//g').each do |g_tag|
      #     g_tag.children.each do |tag|
      #       next if tag.name == "g"
      #       fill_id_class(tag, title, count)
      #       make_specs_array(tag, colors_arr, specs_arr)
      #     end
      # end

      # V: 1.0
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

# Work done by Hassan
      # t_svg = self.description
      # t_svg = t_svg.gsub("<path d", "<path fill='#000000' d")
      # matches = t_svg.scan(/fill=['|"]#\w*\d*\w*\d*['|"]/)
      # matches.each do |fill|
      #   colorCode = fill.split(/#/,-1)[1].split(/"|'/,-1)[0]
      #   t_svg = t_svg.gsub(fill,fill+' class="'+title+'_SVG_#'+colorCode+'"') 
      #   specs_arr << { id: 'svg', color: '#'+colorCode, class: title+'_SVG_#'+colorCode }
      # end
      # self.description = t_svg

      # # t_svg["<path d"] = "<path fill=\"#000000\" d"
      # temarr = []
      # flag = true
      # specs_arr.each do |el|
      #   flag = true
      #   temarr.each do |obj|
      #     if(obj==el)
      #       flag  = false
      #     end
          
      #   end
      #   if(flag)
      #     temarr<<el
      #   end
      # end
      # self.specs = temarr
    end
  end

  def fill_id_class(tag, title, count)
    tag['fill'] = "#000000" if tag['fill'].blank? || tag['fill'] === "none"
    tag['id'] = "#{title}_#{self.sub_category.title}_#{count}"
    tag['class'] = "#{title}_#{self.sub_category.title}_#{tag['fill']}"
    count = count + 1
  end

  def make_specs_array(tag, colors_arr, specs_arr)
    if tag.attributes['fill'].present? && 
        tag.attributes['fill'].value !='none' &&
      !(colors_arr.include? tag.attributes['fill'].value)
      colors_arr << tag.attributes['fill'].value
      specs_arr << { id: tag['id'], color: tag.attributes['fill'].value, class: tag['class'] }
    end
  end

  def fill_id_class(tag, title, count)
    tag['fill'] = "#000000" if tag['fill'].blank? || tag['fill'] === "none"
    tag['id'] = "#{title}_#{self.sub_category.title}_#{count}"
    tag['class'] = "#{title}_#{self.sub_category.title}_#{tag['fill']}"
    count = count + 1
  end

  def make_specs_array(tag, colors_arr, specs_arr)
    if tag.attributes['fill'].present? && 
        tag.attributes['fill'].value !='none' &&
      !(colors_arr.include? tag.attributes['fill'].value)
      colors_arr << tag.attributes['fill'].value
      specs_arr << { id: tag['id'], color: tag.attributes['fill'].value, class: tag['class'] }
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

  # def self.search_keyword(locale = '', keyword)
  #   where("lower(stocks.title#{locale}) LIKE ?", "%#{keyword}%")
  # end

  def self.search_keyword(locale = '', keyword)
    includes(:tags)
    .left_outer_joins(:tags)
    .where("LOWER(stocks.title#{locale}) LIKE :keyword OR
           LOWER(tags.name#{locale}) LIKE :keyword", 
           {:keyword => "%#{keyword.downcase}%"}).uniq if keyword.present?
  end
end