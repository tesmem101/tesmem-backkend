class UserSerializer < ActiveModel::Serializer
  attributes :email, :token, :id, :image
  has_one :image

  def token
    object.user_tokens.last.token
  end
end
