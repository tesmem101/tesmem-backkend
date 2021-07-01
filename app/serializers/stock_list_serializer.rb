class StockListSerializer < ActiveModel::Serializer
  attributes :id, :title, :title_ar, :url, :stocktype,
  :category_id, :sub_category_id, :json, :specs, :created_at, :image, :svg, :svg_thumb

  attribute :clip_path, if: :include_it? 
  attribute :stock_height, key: :height, if: :include_it?
  attribute :stock_width, key: :width, if: :include_it?

  def include_it?
    return true if object.sub_category_id == 34
  end

end
