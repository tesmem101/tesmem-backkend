class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  mount_uploader :profile_photo, ImageUploader

  has_many :user_tokens, dependent: :destroy
  has_many :designs
  has_many :folders
  has_many :uploads
  has_many :images, as: :image

  validates_presence_of :email, uniqueness: true, case_sensitive: false

  before_save do
    self.email = email.downcase if email_changed?
  end

  def self.by_auth_token(token)
    user_token = UserToken.where(token: token).first
    user_token ? user_token.user : nil
  end

  def login!
    self.user_tokens.create
  end

  def logout!(auth_token)
    user_token = UserToken.find_by_token(auth_token)
    user_token.nil? ? false : user_token.destroy
  end
end
