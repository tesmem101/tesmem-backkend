require 'api_exception'

module FetchSuperCategories
  extend ActiveSupport::Concern

  included do
    helpers do
        def all_super_categories
          return Category.where.not(title: TITLES.map{ |key, title| title }).where(super_category_id: nil)
        end
    end
  end
end
