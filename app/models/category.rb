class Category < ApplicationRecord
    attribute :title 
    attribute :description
    has_many :stocks
end
