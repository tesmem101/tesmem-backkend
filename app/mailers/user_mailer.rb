class UserMailer < ApplicationMailer
  def new_password(user)
    @user = user
    mail to: user.email, subject: "Your Tesmem's New Password"
  end
end
