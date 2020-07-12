class CategorySerializer < ActiveModel::Serializer
    attributes :id, :title, :super_category_id, :image, :intermediate_categories, :super_category_id
    has_many :sub_categories
    has_many :stocks
    has_one :image
    has_many :intermediate_categories
end
  