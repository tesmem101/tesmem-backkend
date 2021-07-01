class UserSerializer < ActiveModel::Serializer
  attributes :username, :location, :email, :role, :token, :id, :image, :first_name, :last_name, :confirmed_at, :is_email_confirmed, :is_feedback_available
  has_one :image

  def token
    object.user_tokens.last.token
  end

  def is_email_confirmed
    object.confirmed_at ? true : false
  end

  def location
    object.location ? object.location : ""
  end

  def is_feedback_available
    object.feedback ? true : false
  end

end
