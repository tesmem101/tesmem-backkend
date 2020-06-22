class ContainerSerializer < ActiveModel::Serializer
  attributes :id, :folder_id, :instance_id, :instance_type
end
