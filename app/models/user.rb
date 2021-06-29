class User < ApplicationRecord
  include UserAdmin
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, #:registerable,
         :recoverable, :rememberable, :trackable, 
         :validatable, :confirmable

  mount_uploader :profile, ImageUploader
  has_one :image, as: :image, dependent: :destroy
  after_save :move_profile_photo_to_image_table

  has_many :user_tokens, dependent: :destroy
  has_many :folders, dependent: :destroy
  has_many :designs, dependent: :destroy
  has_many :uploads, dependent: :destroy
  has_many :images, as: :image, dependent: :destroy
  has_many :formatted_texts, dependent: :destroy
  has_one :feedback, dependent: :destroy

  has_many :custom_fonts, dependent: :destroy
  
  enum role: [:user, :admin, :super_admin, :designer, :lead_designer]
  enum identity_provider: [:app, :google, :facebook]

  # validates_presence_of :email, uniqueness: true, case_sensitive: false

  attr_accessor :want_to_change_password

  before_save do
    self.email = email ? email.downcase : nil
    self.username = username ?  username.downcase : nil
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

  def email_confirmation_status!
    self.confirmed_at ? true : false
  end

  def generate_password_token!
    self.reset_password_token = generate_token
    self.reset_password_sent_at = Time.now.utc
    save!
  end

  def password_token_valid?
    (self.reset_password_sent_at + 4.hours) > Time.now.utc
  end

  def update_password!(password)
    self.reset_password_token = nil
    self.password = password
    save!
  end

  def generate_token
    SecureRandom.hex(50)
  end

  def reset_password!
    # self.password = SecureRandom.hex(8)
    self.password = Array.new(8){[*"A".."Z", *"0".."9"].sample}.join
    self.password_confirmation = password
    save!
    UserMailer.new_password(self).deliver
  end

  def move_profile_photo_to_image_table
    if self.profile.blank?
      current_image = "https://tesmem-production.s3.amazonaws.com/uploads/dummy/user.png"
      img = MiniMagick::Image::open(current_image)
      height = img[:height].to_s
      width = img[:width].to_s
      username = self.email
      if Image.where(image: self).present?
        Image.where(image: self).update(name: username, url: current_image, height: height, width: width)
      else
        Image.create(image: self, name: username, url: current_image, height: height, width: width)
      end
    end
    if profile_changed?
      current_image = Rails.env.development? ? "public#{self.profile.thumb.url}" : self.profile.thumb.url
      img = MiniMagick::Image::open(current_image)
      current_image = "#{ENV["HOST_URL"]}#{self.profile.thumb.url}" if Rails.env.development?
      height = img[:height].to_s
      width = img[:width].to_s
      username = self.email
      if Image.where(image: self).present?
        Image.where(image: self).update(name: username, url: current_image, height: height, width: width)
      else
        Image.create(image: self, name: username, url: current_image, height: height, width: width)
      end
    end
  end
end
