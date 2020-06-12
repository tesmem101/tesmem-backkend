class FolderSerializer < ActiveModel::Serializer
  attributes :id, :name, :user_id, :parent_id, :subfolders, :containers
  belongs_to :user
end
