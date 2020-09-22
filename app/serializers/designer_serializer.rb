class DesignerSerializer < ActiveModel::Serializer
    attributes :id, :design
    belongs_to :design
end
  