class CategorySerializer < ActiveModel::Serializer
    attributes :id, :title, :title_ar, :super_category_id, :image, :intermediate_categories, :width, :height, :unit, :designers
    has_many :sub_categories
    has_many :stocks
    has_one :image
    has_many :intermediate_categories
    has_many :designers
end
  