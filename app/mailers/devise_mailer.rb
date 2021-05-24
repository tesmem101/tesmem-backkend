class DeviseMailer < Devise::Mailer
    def confirmation_instructions(record, token, opts={})
     attachments.inline['email_logo.png'] = File.read("#{Rails.root}/app/assets/images/email_logo.png")

     attachments.inline['facebook.svg'] = File.read("#{Rails.root}/app/assets/images/facebook.svg")
     attachments.inline['insta.svg'] = File.read("#{Rails.root}/app/assets/images/insta.svg")
     attachments.inline['twitter.svg'] = File.read("#{Rails.root}/app/assets/images/twitter.svg")
     attachments.inline['snap.svg'] = File.read("#{Rails.root}/app/assets/images/snap.svg")
     attachments.inline['tinder.svg'] = File.read("#{Rails.root}/app/assets/images/tinder.svg")

    #  attachments.inline['android.png'] = File.read("#{Rails.root}/app/assets/images/google.png")
    #  attachments.inline['apple.png'] = File.read("#{Rails.root}/app/assets/images/apple.png")
    #  opts[:from] = "RYSE <ryseup22@gmail.com>"
    #  opts[:subject] = "RYSE Email Confirmation Instruction"
     super
   end
end