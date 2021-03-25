class SubCategory < ApplicationRecord
  include SubCategoryAdmin

  belongs_to :category
  has_many :stocks, dependent: :destroy
  has_many :designers, dependent: :destroy
  has_many :sort_reserved_icons, dependent: :destroy
  validates_presence_of :title
  validates_uniqueness_of :title # , if: -> { category_id == 13 } # This is just for RESERVED_ICONS
  after_save :save_to_reserved_icons


  def save_to_reserved_icons
    if self.category.title.eql?('RESERVED_ICONS')
      SortReservedIcon.find_or_create_by(sub_category_id: self.id, title: self.title)
    end
  end

  def self.search_keyword(locale = '', keyword)
    where("lower(sub_categories.title#{locale}) LIKE ?", "%#{keyword}%")
  end
end
