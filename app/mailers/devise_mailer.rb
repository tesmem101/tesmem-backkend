class DeviseMailer < Devise::Mailer
    def confirmation_instructions(record, token, opts={})
     attachments.inline['email_logo.png'] = File.read("#{Rails.root}/app/assets/images/email_logo.png")
     attachments.inline['facebook_logo.png'] = File.read("#{Rails.root}/app/assets/images/facebook.png")
     attachments.inline['insta.png'] = File.read("#{Rails.root}/app/assets/images/insta.png")
     attachments.inline['twitter.png'] = File.read("#{Rails.root}/app/assets/images/twitter.png")
     attachments.inline['snap.png'] = File.read("#{Rails.root}/app/assets/images/snap.png")
     attachments.inline['tinder.png'] = File.read("#{Rails.root}/app/assets/images/tinder.png")
     super
   end
end