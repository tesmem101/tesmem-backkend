class ImageSerializer < ActiveModel::Serializer
  attribute :name 
  attribute :description
  attribute :url
  attribute :height
  attribute :width
end