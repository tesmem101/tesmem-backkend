class UserSerializer < ActiveModel::Serializer
  attributes :email, :token, :id, :image, :first_name, :last_name
  has_one :image

  def token
    object.user_tokens.last.token
  end
end
