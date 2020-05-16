class SubCategorySerializer < ActiveModel::Serializer
  attributes :id, :title
  has_many :stocks
end
