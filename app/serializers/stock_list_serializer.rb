class StockListSerializer < ActiveModel::Serializer
  attributes :id, :title, :title_ar, :url, :stocktype,
  :category_id, :sub_category_id, :json, :specs, :created_at, :image, :svg, :svg_thumb
end
