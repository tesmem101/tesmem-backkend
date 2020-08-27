class StockSerializer < ActiveModel::Serializer
  attributes :id, :title, :url, :stocktype, :size, :json, :colors
end
