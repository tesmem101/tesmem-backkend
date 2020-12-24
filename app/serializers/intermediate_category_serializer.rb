class IntermediateCategorySerializer < ActiveModel::Serializer
  attributes :id, :title, :title_ar, :super_category_id, :width, :height, :unit
  has_many :sub_categories
  has_many :stocks
end
