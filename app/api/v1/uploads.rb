module V1
  class Uploads < Grape::API
    include AuthenticateUser
    include V1Base
    include SaveImage
    version 'v1', using: :path

    resources :uploads do

      desc 'Add image',
           { consumes: ['application/x-www-form-urlencoded'],
            http_codes: [
             { code: 200, message: 'success' },
             { code: RESPONSE_CODE[:forbidden], message: I18n.t('errors.forbidden') },
             { code: RESPONSE_CODE[:unprocessable_entity], message: 'Validation error messages' },
             { code: RESPONSE_CODE[:not_found], message: I18n.t('errors.not_found') },
           ] }
      params do
        optional :title, type: String, desc: 'Title'
        optional :image, type: File, desc: 'Image file'
        optional :is_trashed, type: Integer, desc: "Trash"
      end
      post '/' do
        params['user_id'] = authenticate_user.id
        upload = Upload.new(params)
        if upload.save!
          insert_image(upload)
          serialization = UploadSerializer.new(upload)
          render_success(serialization.as_json)
        else
          render_error(RESPONSE_CODE[:unauthorized], user.errors.full_messages.join(", "))
        end
      end
      desc "Get Uploads",
           { consumes: ["application/x-www-form-urlencoded"],
             http_codes: [{ code: 200, message: "success" }] }
      get "/" do
        upload = authenticate_user.uploads.where(is_trashed: 0)
        serialization = serialize_collection(upload, serializer: UploadSerializer)
        render_success(serialization.as_json)
      end
      desc 'Update uploads',
           { consumes: ['application/x-www-form-urlencoded'],
            http_codes: [
             { code: 200, message: 'success' },
             { code: RESPONSE_CODE[:forbidden], message: I18n.t('errors.forbidden') },
             { code: RESPONSE_CODE[:unprocessable_entity], message: 'Validation error messages' },
             { code: RESPONSE_CODE[:not_found], message: I18n.t('errors.not_found') },
           ] }
      params do
        requires :id, type: Integer, desc: 'Id'
        optional :title, type: String, desc: 'Title'
        optional :image, type: File, desc: 'Image file'
        optional :is_trashed, type: Integer, desc: "Trash"
      end
      put '/:id' do
        upload = authenticate_user.uploads.find(params[:id])
        if upload.update!(params)
          if params[:image]
            update_image(upload)
          end
          serialization = UploadSerializer.new(upload)
          render_success(serialization.as_json)
        else
          render_error(RESPONSE_CODE[:unauthorized], user.errors.full_messages.join(", "))
        end
      end
      desc 'Delete upload',
           { consumes: ['application/x-www-form-urlencoded'],
             http_codes: [{ code: 200, message: 'success' }] }
      params do
        requires :id, type: Integer, desc: 'Id'
      end
      delete '/:id' do
        authenticate_user.uploads.find(params[:id]).destroy
        render_success("Upload is deleted".as_json)
      end
    end
  end
end
