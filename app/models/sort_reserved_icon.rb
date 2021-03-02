class SortReservedIcon < ApplicationRecord
    include SortReservedIconAdmin
    belongs_to :sub_category
end
