class SortReservedIcon < ApplicationRecord
    include SortReservedIconAdmin
    belongs_to :sub_category

    before_create :assign_position

    private

    def assign_position
        self.position = SortReservedIcon.last ? SortReservedIcon.last.position + 1 : 1
    end
end
