require 'api_exception'

module FetchCategories
  extend ActiveSupport::Concern

  included do
    helpers do
        def all_categories
          return Category.where.not(title: TITLES.map{ |key, title| title }, super_category_id: nil)
        end
    end
  end
end
