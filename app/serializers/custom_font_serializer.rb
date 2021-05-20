class CustomFontSerializer < ActiveModel::Serializer
    attributes :id, :name, :file
    belongs_to :user
end