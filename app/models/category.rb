class Category < ApplicationRecord
    has_many :stocks, dependent: :destroy
end
