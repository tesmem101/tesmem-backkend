class Designer < ApplicationRecord
  include DesignerAdmin
  belongs_to :category
  belongs_to :sub_category
  belongs_to :design
  has_many :template_tags, dependent: :destroy
  has_many :tags, through: :template_tags
  scope :approved, -> { where(approved: true) }
  validates :design_id, uniqueness: { scope: :sub_category_id, message: "is already under selected Sub Category" }
end
