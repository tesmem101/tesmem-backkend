class UserSerializer < ActiveModel::Serializer
  attributes :email
  attribute :token

  def token
    object.user_tokens.last.token
  end
end
