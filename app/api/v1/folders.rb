module V1
  class Folders < Grape::API
    include AuthenticateRequest
    include V1Base
    version 'v1', using: :path

    resource :folders do
      desc 'Create Folder',
           { consumes: ['application/x-www-form-urlencoded'],
            http_codes: [
             { code: 200, message: 'success' },
             { code: RESPONSE_CODE[:forbidden], message: I18n.t('errors.forbidden') },
             { code: RESPONSE_CODE[:unprocessable_entity], message: 'Validation error messages' },
             { code: RESPONSE_CODE[:not_found], message: I18n.t('errors.not_found') },
           ] }
      params do
        requires :name, type: String, desc: 'Name'
        requires :user_id, type: Integer, desc: 'Creator'
      end
      post '/create' do
        folder = Folder.find_or_initialize_by(params)
        if folder.id.nil?
          folder.save!
          serialization = FolderSerializer.new(folder)
          render_success(serialization.as_json)
        else
          render_error(RESPONSE_CODE[:forbidden], 'forbidden', 'Folder already exist'.as_json)
        end
      end

      desc 'Get Folder by UserId',
           { consumes: ['application/x-www-form-urlencoded'],
             http_codes: [{ code: 200, message: 'success' }] }
      get 'user/:user_id' do
        user_id = params[:user_id]
        folder = Folder.where(user_id: user_id)
        serialization = serialize_collection(folder, serializer: FolderSerializer)
        render_success(serialization.as_json)
      end
      desc 'Get Folder by Id',
           { consumes: ['application/x-www-form-urlencoded'],
             http_codes: [{ code: 200, message: 'success' }] }
      get '/:id' do
        folder = Folder.find(params[:id])
        serialization = FolderSerializer.new(folder)
        render_success(serialization.as_json)
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
        requires :user_id, type: Integer, desc: 'Creator'
      end
      put '/:id' do
        folder = Folder.find_or_create_by(params)
        if folder.update!(params)
          serialization = FolderSerializer.new(folder)
          render_success(serialization.as_json)
        else
          render_error(RESPONSE_CODE[:unprocessable_entity], folder.errors.full_messages.join(', '))
        end
      end

      desc 'Delete Folder',
           { consumes: ['application/x-www-form-urlencoded'],
             http_codes: [{ code: 200, message: 'success' }] }
      delete '/:id' do
        Folder.find(params[:id]).destroy
        render_success('Folder deleted'.as_json)
      end
    end
  end
end
