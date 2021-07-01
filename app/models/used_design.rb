class UsedDesign < ApplicationRecord
  belongs_to :user
  belongs_to :design
end
