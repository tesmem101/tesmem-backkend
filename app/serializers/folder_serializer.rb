class FolderSerializer < ActiveModel::Serializer
  attributes :id, :name, :user_id, :parent_id, :subfolders
  belongs_to :user
end
