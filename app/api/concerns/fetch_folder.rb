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
                designs: folder.containers.where(instance_type: 'Design').select{ |container| container.instance.is_trashed == 0 }.map { |container| DesignSerializer.new(container.instance)},
                uploads: folder.containers.where(instance_type: 'Upload').select{ |container| container.instance.is_trashed == 0 }.map { |container| UploadSerializer.new(container.instance) }
            } }
            return folders
        end
    end
  end
end
