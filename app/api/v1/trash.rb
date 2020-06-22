module V1
  class Trash < Grape::API
    include AuthenticateUser
    include V1Base
    version 'v1', using: :path

    resource :trash do

      desc 'Get all trashed',
           { consumes: ['application/x-www-form-urlencoded'],
            http_codes: [
             { code: 200, message: 'success' },
             { code: RESPONSE_CODE[:forbidden], message: I18n.t('errors.forbidden') },
             { code: RESPONSE_CODE[:unprocessable_entity], message: 'Validation error messages' },
             { code: RESPONSE_CODE[:not_found], message: I18n.t('errors.not_found') },
           ] }
      get '/' do
        designs = authenticate_user.designs.where(is_trashed: 1)
        uploads = authenticate_user.uploads.where(is_trashed: 1)
        all_trash = {
          designs: serialize_collection(designs, serializer: DesignSerializer),
          uplaods: serialize_collection(uploads, serializer: UploadSerializer)
        }
        render_success(all_trash.as_json)
      end
    end
  end
end
