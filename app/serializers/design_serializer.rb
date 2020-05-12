class DesignSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :styles, :user
  belongs_to :user
end
