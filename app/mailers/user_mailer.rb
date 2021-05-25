class UserMailer < ApplicationMailer
  def new_password(user)
    @user = user
    mail to: user.email, subject: "Your Tesmem's New Password"
  end

  def forgot_password(user, link)
    @user = user
    @link = link
    mail to: @user.email, subject: "Reset your Tesmem's password"
  end

end
