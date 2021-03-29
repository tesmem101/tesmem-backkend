class SortReservedIcon < ApplicationRecord
    include SortReservedIconAdmin
    belongs_to :sub_category
    before_create :assign_position

    def self.sub_categories_which_has_stocks
        where(
            sub_category_id: Category.find_by(title: TITLES[:icon])
            .sub_categories
            .joins(:stocks)
            .select("distinct sub_categories.id")
        )
    end

    private

    def assign_position
        self.position = SortReservedIcon.last ? SortReservedIcon.last.position + 1 : 0
    end
end
