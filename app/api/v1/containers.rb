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
        params['options'] = OPTIONS[params['options'].to_sym]
        render_error(RESPONSE_CODE[:unprocessable_entity], I18n.t("errors.folder.not_processed")) if !params['options']
        container = Container.new(params)
        if container.save!
          render_success(container.as_json)
        else
          render_error(RESPONSE_CODE[:unauthorized], I18n.t("errors.folder.not_processed"))
        end
      end
      
    end
  end
end