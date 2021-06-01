class SortSubCategory < ApplicationRecord
  belongs_to :category
  belongs_to :sub_category
  before_create :assign_position

  scope :stocks, -> { where(
    sub_category_id: Category.find_by(title: TITLES[:stock])
    .sub_categories
    .joins(:stocks)
    .select("distinct sub_categories.id")
)}

scope :facebook_story, -> { where(
  sub_category_id: Category.find_by(id: 11)
  .sub_categories
  .joins(:designers)
  .select("distinct sub_categories.id")
)}

  private

  def assign_position
    s_sub_c = SortSubCategory.where(category_id: self.category_id).last
    self.position = s_sub_c ? s_sub_c.position + 1 : 0
  end

end
