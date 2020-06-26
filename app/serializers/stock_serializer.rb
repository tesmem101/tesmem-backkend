class StockSerializer < ActiveModel::Serializer
  attributes :id, :title, :url, :stocktype, :height, :size, :json
end
