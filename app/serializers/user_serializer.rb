class UserSerializer < ActiveModel::Serializer
  attributes :username, :location, :email, :role, :token, :id, :image, :first_name, :last_name, :confirmed_at, :is_email_confirmed
  has_one :image

  def token
    object.user_tokens.last.token
  end

  def is_email_confirmed
    object.confirmed_at ? true : false
  end

end
