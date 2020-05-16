class CategorySerializer < ActiveModel::Serializer
    attributes :id, :title
    has_many :sub_categories
    has_many :stocks
end
  