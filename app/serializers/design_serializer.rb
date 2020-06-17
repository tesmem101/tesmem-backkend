class DesignSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :styles, :height, :width, :images, :user
  belongs_to :user
end