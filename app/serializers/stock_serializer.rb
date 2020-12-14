class StockSerializer < ActiveModel::Serializer
  attributes :id, :title, :title_ar, :description, :url, :stocktype, :json, :specs
end
