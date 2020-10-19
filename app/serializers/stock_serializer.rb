class StockSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :url, :stocktype, :json, :specs
end
