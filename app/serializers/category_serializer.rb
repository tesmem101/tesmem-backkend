class CategorySerializer < ActiveModel::Serializer
  attributes :id, :title, :title_ar, :super_category_id, :intermediate_categories, :width, :height, :unit, :designers
  attribute :image , if: :include_image?
  has_many :sub_categories
  has_many :stocks
  has_one :image
  has_many :intermediate_categories
  has_many :designers

  def include_image?
    return true if @instance_options[:is_image] == true
  end
end
