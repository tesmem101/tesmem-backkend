class DesignSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :styles, :height, :width, :is_trashed, :images, :container, :user
  has_many :images
  has_one :container
  belongs_to :user
end
