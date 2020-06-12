module V1
  class Containers < Grape::API
    include AuthenticateUser
    include V1Base
    version 'v1', using: :path

    resource :containers do

      desc 'Create Container',
           { consumes: ['application/x-www-form-urlencoded'],
            http_codes: [
             { code: 200, message: 'success' },
             { code: RESPONSE_CODE[:forbidden], message: I18n.t('errors.forbidden') },
             { code: RESPONSE_CODE[:unprocessable_entity], message: 'Validation error messages' },
             { code: RESPONSE_CODE[:not_found], message: I18n.t('errors.not_found') },
           ] }
      params do
        requires :folder_id, type: Integer, desc: 'Folder id'
        requires :type_id, type: Integer, desc: 'Type id'
        requires :options, type: String, desc: 'Options'
      end
      post :create do
        puts "#{params['folder_id']} ---- #{params['type_id']} ------ #{params['options']}"
        # container = Container.new(params)
        # if container.save!
        #   # serialization = FolderSerializer.new(folder)
        #   render_success(container.as_json)
        # else
        #   render_error(RESPONSE_CODE[:unauthorized], I18n.t("errors.folder.not_processed"))
        # end
      end

      desc "Get folders",
           { consumes: ["application/x-www-form-urlencoded"],
             http_codes: [{ code: 200, message: "success" }] }
      get "/" do
        folders = authenticate_user.folders.where(parent_id: nil)
        allFolder = folders.map { |folder| { 
            id: folder.id,
            name: folder.name,
            parent_id: folder.parent_id,
            folders: folder.subfolders,
            designs: folder.containers.map { |cont| serialize_collection(authenticate_user.designs.where(id: cont.type_id), serializer: DesignSerializer).first }
        } }
        render_success(allFolder.as_json)
      end

      desc 'Show folder',
           { consumes: ['application/x-www-form-urlencoded'],
             http_codes: [{ code: 200, message: 'success' }] }
      get '/:id' do
        folder = authenticate_user.folders.where(id: params[:id])
        allFolder = folder.map { |folder| { 
            id: folder.id,
            name: folder.name,
            parent_id: folder.parent_id,
            folders: folder.subfolders,
            designs: folder.containers.map { |cont| serialize_collection(authenticate_user.designs.where(id: cont.type_id), serializer: DesignSerializer).first }
        } }
        render_success(allFolder.as_json)
      end

      desc 'Update Folder',
           { consumes: ['application/x-www-form-urlencoded'],
            http_codes: [
             { code: 200, message: 'success' },
             { code: RESPONSE_CODE[:forbidden], message: I18n.t('errors.forbidden') },
             { code: RESPONSE_CODE[:unprocessable_entity], message: 'Validation error messages' },
             { code: RESPONSE_CODE[:not_found], message: I18n.t('errors.not_found') },
           ] }
      params do
        requires :name, type: String, desc: 'Name'
      end
      put '/:id' do
        params['user_id'] = authenticate_user.id
        folder = authenticate_user.folders.where(id: params[:id])
        if folder.update(params)
          serialization = serialize_collection(folder, serializer: FolderSerializer)
          render_success(folder.as_json)
        else
          render_error(RESPONSE_CODE[:unprocessable_entity], folder.errors.full_messages.join(', '))
        end
      end

      desc 'Delete Folder',
           { consumes: ['application/x-www-form-urlencoded'],
             http_codes: [{ code: 200, message: 'success' }] }
      delete '/:id' do
        authenticate_user.folders.find(params[:id]).destroy
        render_success("Folder is deleted".as_json)
      end
    end
  end
end