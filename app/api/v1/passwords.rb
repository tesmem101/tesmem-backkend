module V1
    class Passwords < Grape::API
      include V1Base
      version 'v1', using: :path
  
      resource :passwords do
        desc 'Forgot Password'
        params do
          requires :email, type: String, desc: 'User email'
          optional :link, type: String, desc: 'Link'
        end
        post :forgot do
          if params[:email].blank? # check if email is present
            render_error(nil, 'Email not present')
          end
          user = User.find_by(email: params[:email]) # if present find user by email
          if user.present?
            user.generate_password_token! #generate pass token
            link = params[:link] ? "#{params[:link]}?token=#{user.reset_password_token}" : "#{ENV['HOST_URL']}?token=#{user.reset_password_token}" 
            UserMailer.forgot_password(user, link).deliver
            render_success(nil, 'Email has been sent to your provided email.')
          else
            render_error(nil, 'Email address not found. Please check and try again.')
          end
        end
  
        desc 'Reset Password'
        params do
          requires :token, type: String, desc: 'Reset Password Token'
          requires :new_password, type: String, desc: 'User New Password'
        end
        post :reset do
          if params[:email].blank?
            render_success(nil, 'Token not present!')
          end
          token = params[:token]
          user = User.find_by(reset_password_token: token)
  
          if user.present? && user.password_token_valid?
            if user.update_password!(params[:new_password])
              render_success(nil, 'Password Resest Successfully!')
            else
              render_error(RESPONSE_CODE[:unprocessable_entity], user.errors.full_messages)
            end
          else
            render_error(RESPONSE_CODE[:unprocessable_entity], 'Link not valid or expired. Try generating a new link!')
          end
        end
      end
    end
end