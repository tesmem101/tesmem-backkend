class Designer < ApplicationRecord
    belongs_to :category
    belongs_to :sub_category
    belongs_to :design
  end
  