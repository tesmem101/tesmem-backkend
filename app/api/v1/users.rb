module V1
  class Users < Grape::API
    include AuthenticateRequest
    include AuthenticateUser
    include V1Base
    include AuthenticateAdmin
    version 'v1', using: :path

    resource :users do

      desc 'User Feedback'
      params do
        requires :happy, type: Boolean, desc: 'Happy State'
        optional :feedback, type: String, desc: 'Reason for not beeing happy'
      end
      post :feedback do
        user = authenticate_user
        user.create_feedback(happy: params[:happy], feedback: params[:feedback])
        render_success(nil, 'Thanks for submitting the feedback!')
      end

      desc 'Help email'
      params do
        requires :title, type: String, desc: 'Title of Email'
        requires :body, type: String, desc: 'Body of Email'
      end
      post :help_email do
        user = authenticate_user
        title = params[:title]
        body = params[:body]
        UserMailer.help(title, body, user).deliver_later
        Email.create(from: 'info@tesmem.com', to: 'dev@tesmem.com', title: title, body: body, sent_at: Time.now, email_type: 'help')
        render_success(nil, 'Thanks! we will respond back to you by email.')
      end
      
      desc 'Check Username'
      get :check_username do
        username = params[:username]
        user = User.find_by_username(username)
        if user.present?
          render_success({is_available: false})
        else
          render_success({is_available: true})
        end
      end

      desc 'Check Email'
      get :check_email do
        email = params[:email]
        user_email = User.find_by_email(email)
        if user_email.present?
          render_success({is_available: false})
        else
          render_success({is_available: true})
        end
      end

      desc 'Verify Email'
      post :verify_email do
        user = authenticate_user
        if user
          unless user.confirmed_at
            user.resend_confirmation_instructions
            render_success(nil, "An email verification link has been sent to your email. Please check your email and complete the sign up process.")
          else
            render_error(nil, 'Email is already confirmed.')
          end
        end
      end

      desc 'Change Password'
      params do
        # requires :old_password, type: String, desc: 'Old Password'
        requires :password, type: String, desc: 'New Password'
        # requires :password_confirmation, type: String, desc: 'New Confirm Password'
      end

      put :change_password do
        user = authenticate_user
        user.password = params[:password]
        user.password_confirmation = params[:password]
        user.save!
        render_success(nil, 'Password Changed')
        # if user.valid_password?(params[:old_password])
        #   unless params[:password] == params[:old_password]
        #     user.password = params[:password]
        #     user.password_confirmation = params[:password_confirmation]
        #     user.save!
        #     render_success(nil, 'Password Changed')
        #   else
        #     render_error(nil, 'Hey! You Cannot set old password as a new password')
        #   end
        # else
        #   render_error(nil, 'Sorry! Password does not change because your Old Passsword was not correct')
        # end
      end

      desc 'Sign Out From All Devices'
      before { authenticate_user }
      delete '/:id/sign_out_from_devices' do
        user = User.find(params[:id])
        if user
          user.user_tokens.destroy_all
          render_success(nil, 'All Sessions are expired now')
        else
          render_error(nil, 'User not found!')
        end
      end

      desc 'Delete Account'
      params do
        requires :reason, type: String, desc: 'Reason for account deletion'
      end

      delete :delete_account do
        user = authenticate_user
        if user
          if !(['admin', 'super_admin', 'designer', 'lead_designer'].include?(user.role))
            email = user.email
            user.destroy
            DeletedAccount.create!(user_email: email, reason: params[:reason])
            render_success(nil, 'Accunt is deleted now')
          else
            render_error(nil, 'You cannot delete the account!')
          end
        else
          render_error(nil, 'User not found!')
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
        requires :id, type: String, desc: 'user id'
        optional :profile, type: File, desc: 'Profile photo'
        optional :first_name, type: String, desc: 'First name'
        optional :last_name, type: String, desc: 'Last name'
        optional :location, type: String, desc: 'Location'
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
      # before { authenticate_admin }
      params do
        requires :email, type: String, desc: 'Email'
        requires :role, type: String, desc: 'Role'
      end
      put '/update/role/:id' do
        authenticate_admin
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
