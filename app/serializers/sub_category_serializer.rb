class SubCategorySerializer < ActiveModel::Serializer
  attributes :id, :title, :title_ar
  has_many :stocks
end
