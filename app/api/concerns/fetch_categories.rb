require 'api_exception'

module FetchCategories
  extend ActiveSupport::Concern

  included do
    helpers do
        def all_categories
          Category.where.not(title: TITLES.values, super_category_id: nil)
        end
        def all_super_categories
          Category.where.not(title: TITLES.values).where(super_category_id: nil)
        end
        def fetch_categories(categories)
          return {
            id: categories.id,
            title: categories.title,
            title_ar: categories.title_ar,
            super_category_id: categories.super_category_id,
            width: categories.width,
            height: categories.height,
            unit: categories.unit,
            image: ImageSerializer.new(categories.image),
            stocks: categories.designers.includes(:design).all.filter { |designer, key|
              designer.approved
            }.map { |designer, key| 
              {
                id: designer.design.id,
                title: designer.design.title,
                url: designer.design.image.thumb.url,
                json: designer.design.styles,
                height: designer.design.height,
                width: designer.design.width,
                is_trashed: designer.design.is_trashed,
              }
            }
          }
        end
        def fetch_super_categories(super_cat)
          return {
            id: super_cat.id,
            title: super_cat.title,
            title_ar: super_cat.title_ar,
            intermediate_categories: super_cat.intermediate_categories.includes(:designers, :image).all.map { |cat| fetch_categories(cat) },
            stocks: []
          }
        end
    end
  end
end
