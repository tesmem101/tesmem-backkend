module V1
  class Users < Grape::API
    include AuthenticateRequest
    include AuthenticateUser
    include V1Base
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
        requires :email, type: String, desc: 'Email'
      end
      put '/:id' do
        user = User.where(id: params[:id], email: params[:email])
        if user.update(params)
          serialization = UserSerializer.new(user)
          render_success(serialization.as_json)
        else
          render_error(RESPONSE_CODE[:unauthorized], user.errors.full_messages.join(', '))
        end
      end
      desc 'Update user role',
        { consumes: [ 'application/x-www-form-urlencoded' ],
          http_codes: [
            { code: 200, message: 'success' },
            { code: RESPONSE_CODE[:forbidden], message: I18n.t('errors.forbidden') },
            { code: RESPONSE_CODE[:unprocessable_entity], message: 'Validation error messages' },
            { code: RESPONSE_CODE[:not_found], message: I18n.t('errors.not_found') }
        ]}
      params do
        requires :email, type: String, desc: 'Email'
        requires :role, type: String, desc: 'Role'
      end
      put '/update/role/:id' do
        user = User.where(id: params[:id], email: params[:email]).first
        if user && user.update(role: params[:role])
          serialization = UserSerializer.new(user)
          render_success(serialization.as_json)
        else
          render_error(RESPONSE_CODE[:not_found], I18n.t('errors.not_found'))
        end
      end
    end
  end
end
