class SubCategory < ApplicationRecord
  include SubCategoryAdmin

  belongs_to :category
  has_many :stocks, dependent: :destroy
  has_many :designers, dependent: :destroy


  def self.search_keyword(locale = '', keyword)
    where("lower(sub_categories.title#{locale}) LIKE ?", "%#{keyword}%")
  end
end
