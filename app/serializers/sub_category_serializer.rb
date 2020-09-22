class SubCategorySerializer < ActiveModel::Serializer
  attributes :id, :title, :title_ar, :designers, :stocks
  has_many :stocks
  has_many :designers
end
