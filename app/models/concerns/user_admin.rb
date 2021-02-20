module UserAdmin
  extend ActiveSupport::Concern

  included do
    rails_admin do
      list do
        field :id
        # field :first_name
        # field :last_name
        field :email
        field :phone_number
        field :role
        field :sign_in_count
        field :created_at
      end
      show do
        include_fields :id, :first_name, :last_name, :email, :phone_number, :role, :profile, 
          :sign_in_count, :created_at, :updated_at, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :reset_password_token, :reset_password_sent_at, :remember_created_at, :identity_provider, :identity_provider_id
      end
      edit do
        include_fields :email, :password, :password_confirmation, :first_name, :last_name,
          :phone_number, :role, :profile
      end
    end
  end
end