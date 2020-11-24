class UploadSerializer < ActiveModel::Serializer
  attributes :id, :title, :is_trashed, :images, :container, :user
  has_one :container
  has_many :images, serializer: ImageSerializer
  belongs_to :user
end
