class SubCategory < ApplicationRecord
  include SubCategoryAdmin

  belongs_to :category
  has_many :stocks, dependent: :destroy
  has_many :designers, dependent: :destroy
  # has_many :sort_reserved_icons, dependent: :destroy
  has_many :sort_sub_categories, dependent: :destroy
  validates_presence_of :title
  validates_uniqueness_of :title # , if: -> { category_id == 13 } # This is just for RESERVED_ICONS

  # after_save :save_to_reserved_icons
  after_save :save_to_sort_sub_categories

  before_destroy :can_destroy?, prepend: true

  private

  def can_destroy?
    if self.stocks.any? || self.designers.any?
      errors.add :base, message: 'This Sub-Category Has Some Dependent Stocks/Templates. You Need to first Delete Dependent Data!' # 'You Do Not Have Permission To Perform This Action!'
      throw :abort
    end
  end

  # def save_to_reserved_icons
  #   if self.category.title.eql?(TITLES[:stock]) # TITLES object is in db_constants file
  #     s_r_i = SortReservedIcon.find_by(sub_category_id: self.id)
  #     if s_r_i
  #       s_r_i.update(title: self.title)
  #     else
  #       SortReservedIcon.create(sub_category_id: self.id, title: self.title)
  #     end
  #   end
  # end

  def save_to_sort_sub_categories
    s_sub_c = SortSubCategory.find_by(category_id: self.category.id, sub_category_id: self.id)
    if s_sub_c
      s_sub_c.update(sub_category_title: self.title)
    else
      SortSubCategory.create(category_id: self.category.id, sub_category_id: self.id, sub_category_title: self.title)
    end
  end

  def self.search_keyword(locale = '', keyword)
    where("lower(sub_categories.title#{locale}) LIKE ?", "%#{keyword}%")
  end
end
