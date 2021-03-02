class Designer < ApplicationRecord
  include DesignerAdmin
  belongs_to :category
  belongs_to :sub_category
  belongs_to :design

  scope :approved, -> { where(approved: true) }
end
