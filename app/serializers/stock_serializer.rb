class StockSerializer < ActiveModel::Serializer
  attributes :id, :title, :path, :category

  def category
    CategorySerializer.new(object.category)
  end
end
