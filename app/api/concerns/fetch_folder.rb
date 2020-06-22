require 'api_exception'

module FetchFolder
  extend ActiveSupport::Concern

  included do
    helpers do
        def get_folder(folder)
            folders = folder.map { |folder| {
                id: folder.id,
                name: folder.name,
                parent_id: folder.parent_id,
                subfolders: serialize_collection(folder.subfolders, serializer: FolderSerializer),
                designs: folder.containers.where(instance_type: 'Design').select{ |container| container.instance.is_trashed == 0 }.map { |container| {container_id: container.id, design_id: container.instance.id, images: serialize_collection(container.instance.images, serializer: ImageSerializer) } },
                uploads: folder.containers.where(instance_type: 'Upload').select{ |container| container.instance.is_trashed == 0 }.map { |container| {container_id: container.id, upload_id: container.instance.id, images: serialize_collection(container.instance.images, serializer: ImageSerializer) } },
            } }
            return folders
        end
    end
  end
end
