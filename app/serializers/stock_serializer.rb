class StockSerializer < ActiveModel::Serializer
  attributes :id, :title, :url, :stocktype, :json, :colors
end
