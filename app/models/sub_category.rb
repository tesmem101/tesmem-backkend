class SubCategory < ApplicationRecord
  belongs_to :category
  has_many :stocks, dependent: :destroy
  has_many :designers, dependent: :destroy
end
