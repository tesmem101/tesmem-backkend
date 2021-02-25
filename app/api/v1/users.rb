module V1
  class Users < Grape::API
    include AuthenticateRequest
    include AuthenticateUser
    include V1Base
    include AuthenticateAdmin
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
      desc 'Update user role',
        { consumes: [ 'application/x-www-form-urlencoded' ],
          http_codes: [
            { code: 200, message: 'success' },
            { code: RESPONSE_CODE[:forbidden], message: I18n.t('errors.forbidden') },
            { code: RESPONSE_CODE[:unprocessable_entity], message: 'Validation error messages' },
            { code: RESPONSE_CODE[:not_found], message: I18n.t('errors.not_found') }
        ]}
      before { authenticate_admin }
      params do
        requires :email, type: String, desc: 'Email'
        requires :role, type: String, desc: 'Role'
      end
      put '/update/role/:id' do
        user = User.where(id: params[:id], email: params[:email])
        if(user.length() > 0)
          if user.first.update(role: params[:role])
            serialization = UserSerializer.new(user.first)
            render_success(serialization.as_json)
          else
            render_error(RESPONSE_CODE[:not_found], I18n.t('errors.not_found'))
          end
        else
          render_error(RESPONSE_CODE[:not_found], I18n.t('errors.user.not_found'))
        end
      end

      desc 'Get Desing on User and Design Id base',
        { consumes: [ 'application/x-www-form-urlencoded' ],
          http_codes: [
            { code: 200, message: 'success' },
            { code: RESPONSE_CODE[:forbidden], message: I18n.t('errors.forbidden') },
            { code: RESPONSE_CODE[:unprocessable_entity], message: 'Validation error messages' },
            { code: RESPONSE_CODE[:not_found], message: I18n.t('errors.not_found') }
        ]}
      before { authenticate_user }
      get '/:user_id/designs/:id' do
        user = User.find(params[:user_id])
        if user
          design = Design.find_by(id: params[:id],user_id: user.id)
          design = {id: params[:id], user_id: user.id, json: design.styles}
          render_success(design.as_json)          
        end
      end

    end
  end
end
