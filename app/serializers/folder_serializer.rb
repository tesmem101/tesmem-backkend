class FolderSerializer < ActiveModel::Serializer
  attributes :id, :name, :parent_id, :subfolders, :user
  has_many :subfolders
  belongs_to :user
end
