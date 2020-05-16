class SubCategory < ApplicationRecord
  belongs_to :category
  has_many :stocks, dependent: :destroy
end
