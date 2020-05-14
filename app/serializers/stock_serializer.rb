class StockSerializer < ActiveModel::Serializer
  attributes :id, :title, :source, :stocktype, :height, :size
end
