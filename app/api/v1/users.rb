module V1
  class Users < Grape::API
    include AuthenticateRequest
    include V1Base
    include AuthenticateUser
    version 'v1', using: :path

    resource :users do

      desc 'Update a User',
        { consumes: [ 'application/x-www-form-urlencoded' ],
          http_codes: [
            { code: 200, message: 'success' },
            { code: RESPONSE_CODE[:forbidden], message: I18n.t('errors.forbidden') },
            { code: RESPONSE_CODE[:unprocessable_entity], message: 'Validation error messages' },
            { code: RESPONSE_CODE[:not_found], message: I18n.t('errors.not_found') }
        ]}
      params do
        requires :id, type: String, desc: 'user id'
        optional :profile, type: File, desc: 'Profile photo'
      end
      put '/:id' do
        if authenticate_user.email != User.find(params[:id]).email
          render_error(RESPONSE_CODE[:unauthorized], message: I18n.t('errors.not_found')) 
        end
        if params[:role]
          render_error(RESPONSE_CODE[:unauthorized], "You are not allowed to alter role")
        end
        if authenticate_user.update(params)
          serialization = UserSerializer.new(authenticate_user)
          render_success(serialization.as_json)
        else
          render_error(RESPONSE_CODE[:unauthorized], authenticate_user.errors.full_messages.join(', '))
        end
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
