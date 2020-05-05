class StockSerializer < ActiveModel::Serializer
  attributes :title
  attribute :description
  attribute :path
  attribute :category_id
end
