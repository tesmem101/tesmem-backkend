module V1
  class Sessions < Grape::API
    include AuthenticateRequest
    include V1Base
    version 'v1', using: :path

    resource :sessions do
      desc 'Sign up',
        { consumes: [ 'application/x-www-form-urlencoded' ],
          http_codes: [
            { code: 200, message: 'success' },
            { code: RESPONSE_CODE[:forbidden], message: I18n.t('errors.forbidden') },
            { code: RESPONSE_CODE[:unprocessable_entity], message: 'Validation error messages' },
            { code: RESPONSE_CODE[:not_found], message: I18n.t('errors.not_found') }
        ]}
      params do
        requires :email, type: String, desc: 'Email'
        requires :password, type: String, desc: 'Password'
        requires :password_confirmation, type: String, desc: 'Password confirmation'
      end

      post :sign_up do
        user = User.new(params)
        if user.save
          user.login!
          serialization = UserSerializer.new(user)
          render_success(serialization.as_json)
        else
          render_error(RESPONSE_CODE[:unauthorized], user.errors.full_messages.join(', '))
        end
      end

      desc 'Sign in user',{
        consumes: [ 'application/x-www-form-urlencoded' ],
        http_codes: [
          { code: 200, message: 'success'},
          { code: RESPONSE_CODE[:unauthorized], message: I18n.t('errors.session.invalid') }
        ]
      }
      params do
        requires :email, type: String, desc: 'User email'
        requires :password, type: String, desc: 'User Password'
      end

      post :sign_in do
        email = params[:email]
        password = params[:password]
        user = User.where(email: email.downcase).first
        if user.nil? || !user.valid_password?(password)
          render_error(RESPONSE_CODE[:unauthorized], I18n.t('errors.session.invalid'))
        end

        user.login!
        serialization = UserSerializer.new(user)
        render_success(serialization.as_json)
      end

      desc 'Sign in/up user via google',{
        consumes: [ 'application/x-www-form-urlencoded' ],
        http_codes: [
          { code: 200, message: 'success'},
          { code: RESPONSE_CODE[:unauthorized], message: I18n.t('errors.session.invalid') }
        ]
      }
      params do
        requires :email, type: String, desc: 'User email'
        requires :google_id, type: String, desc: 'Google Id'
      end

      post :google_sign_in do
        email = params[:email]
        google_id = params[:google_id]
        user = User.where(email: email.downcase).first
        if user.nil?
          user = User.new(email: email.downcase, password: 'password', password_confirmation: 'password')
          user.save
        end

        user.login!
        serialization = UserSerializer.new(user)
        render_success(serialization.as_json)
      end

      desc 'Sign in/up user via facebook',{
        consumes: [ 'application/x-www-form-urlencoded' ],
        http_codes: [
          { code: 200, message: 'success'},
          { code: RESPONSE_CODE[:unauthorized], message: I18n.t('errors.session.invalid') }
        ]
      }
      params do
        requires :email, type: String, desc: 'User email'
        requires :fb_id, type: String, desc: 'Facebook Id'
      end

      post :facebook_sign_in do
        email = params[:email]
        fb_id = params[:fb_id]
        user = User.where(email: email.downcase).first
        if user.nil?
          user = User.new(email: email.downcase, password: 'password', password_confirmation: 'password')
          user.save
        end

        user.login!
        serialization = UserSerializer.new(user)
        render_success(serialization.as_json)
      end

      desc 'Sign Out', headers: HEADERS_DOCS, http_codes: [
        { code: 200, message: 'success' },
        { code: RESPONSE_CODE[:unauthorized], message: I18n.t('errors.session.invalid_token') }
      ]
      delete :sign_out do
        # current_user.authenticate!
        auth_token = headers['Authorization']
        if current_user.logout!(auth_token)
          render_success('Logged out'.as_json)
        else
          render_error(RESPONSE_CODE[:unauthorized], I18n.t('errors.session.invalid_token'))
        end
      end
    end
  end
end
