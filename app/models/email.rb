class Email < ApplicationRecord
    enum email_type: [:confirmation, :forgot_password, :feedback, :help]
end
