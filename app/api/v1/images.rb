module V1
  class Images < Grape::API
    include AuthenticateRequest
    include V1Base
    version 'v1', using: :path

    resource :images do

      desc 'Create an Image',
        { consumes: [ 'application/x-www-form-urlencoded' ],
          http_codes: [
            { code: 200, message: 'success' },
            { code: RESPONSE_CODE[:forbidden], message: I18n.t('errors.forbidden') },
            { code: RESPONSE_CODE[:unprocessable_entity], message: 'Validation error messages' },
            { code: RESPONSE_CODE[:not_found], message: I18n.t('errors.not_found') }
        ]}
      params do
        requires :name, type: String, desc: 'Name'
        requires :pata, type: String, desc: 'Pata'
      end

      put :create do
        image = Image.new(params)
        if image.save!(params)
          serialization = ImageSerializer.new(image)
          render_success(serialization.as_json)
        else
          render_error(RESPONSE_CODE[:unauthorized], user.errors.full_messages.join(', '))
        end
      end


      desc 'Update a User',
        { consumes: [ 'application/x-www-form-urlencoded' ],
          http_codes: [
            { code: 200, message: 'success' },
            { code: RESPONSE_CODE[:forbidden], message: I18n.t('errors.forbidden') },
            { code: RESPONSE_CODE[:unprocessable_entity], message: 'Validation error messages' },
            { code: RESPONSE_CODE[:not_found], message: I18n.t('errors.not_found') }
        ]}
      params do
        requires :email, type: String, desc: 'Email'
      end

      put :update do
        if current_user.update!(params)
          serialization = UserSerializer.new(current_user)
          render_success(serialization.as_json)
        else
          render_error(RESPONSE_CODE[:unauthorized], user.errors.full_messages.join(', '))
        end
      end
    end
  end
end
