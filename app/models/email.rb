class Email < ApplicationRecord
    enum type: [:confirmation, :forgot_password, :feedback, :help]
end
