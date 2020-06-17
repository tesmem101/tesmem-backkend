class UserSerializer < ActiveModel::Serializer
  attributes :email
  attribute :token
  attribute :id

  def token
    object.user_tokens.last.token
  end
end
