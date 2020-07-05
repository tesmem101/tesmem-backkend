require 'api_exception'

module FetchSubCategories
  extend ActiveSupport::Concern

  included do
    helpers do
        def all_sub_categories
          return SubCategory.where.not(title: TITLES.map{ |key, title| title })
        end
    end
  end
end
