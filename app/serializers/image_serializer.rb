class ImageSerializer < ActiveModel::Serializer
  attributes :name, :description, :url, :height, :width
end
