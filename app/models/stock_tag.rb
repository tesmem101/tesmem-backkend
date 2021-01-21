class StockTag < ApplicationRecord
  belongs_to :stock
  belongs_to :tag
end
