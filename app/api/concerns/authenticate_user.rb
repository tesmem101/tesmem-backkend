require 'api_exception'

module AuthenticateUser
  extend ActiveSupport::Concern

  included do
    helpers do

      def authenticate_user
        auth_token = !request.headers["Authorization"].blank? ? request.headers["Authorization"] : nil
        if !auth_token
          render_error(RESPONSE_CODE[:unauthorized], I18n.t("errors.user.not_found"))
        end
        user_token = UserToken.where(token: auth_token).first
        if !user_token
          render_error(RESPONSE_CODE[:unauthorized], I18n.t("errors.session.invalid_token"))
        end
        @authenticate_user = user_token.user
      end
      def authenticate_admin
        auth_token = !request.headers["Authorization"].blank? ? request.headers["Authorization"] : nil
        if !auth_token
          render_error(RESPONSE_CODE[:unauthorized], I18n.t("errors.user.not_found"))
        end
        user_token = UserToken.where(token: auth_token).first
        if !user_token
          render_error(RESPONSE_CODE[:unauthorized], I18n.t("errors.session.invalid_token"))
        end
        if user_token.user.role != "super_admin"
          render_error(RESPONSE_CODE[:unauthorized], I18n.t("errors.super_admin.is_required"))
        end
      end
    end
  end
end
