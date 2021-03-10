module V1
  class Templates < Grape::API
    include AuthenticateRequest
    include V1Base
    include FetchTemplate
    include FetchCategories
    require 'will_paginate/array'
    version "v1", using: :path

    resource :templates do

      desc 'Query String search by Category Id and title',
           { consumes: ['application/x-www-form-urlencoded'],
             http_codes: [{ code: 200, message: 'success' }] }

      params do
        requires :page, type: String, :desc => 'Page Number'
        requires :per_page, type: String, :desc => 'Number of elements on each page'
      end
      get '/' do
        if params['locale'].present?
          if params['locale'] != "ar"
            render_error(RESPONSE_CODE[:not_found], I18n.t("errors.locale.not_found"))
          end
        end
        cat_id = params['category_id'].present? ? params['category_id'] : nil
        search = params['search'].present? ? params['search'].downcase : nil
        locale = params['locale'].present? ? "_#{params['locale']}" : ""

        if cat_id && search
          templates_ids = Category.find(cat_id).sub_categories.joins(:designers).joins("inner join designs on designs.id = designers.design_id").joins("left join template_tags on template_tags.designer_id = designers.id").joins("left join tags on template_tags.tag_id = tags.id").where("lower(designs.title#{locale}) LIKE ? or lower(tags.name) LIKE ?", "%#{search}%", "%#{search}%").select("designs.id")
          templates = Design.where(id: templates_ids).collect{ |design| make_design_object(design) }
        elsif cat_id
          templates = Category.find(cat_id).sub_categories.search_keyword(locale, search).includes(:designers).all.map { |sub_c| get_template(sub_c) } # Previous One 
        else
          templates = all_categories.includes(:sub_categories).all
            .map { |cat| 
                cat.sub_categories.search_keyword(locale, search)
                .includes(:designers).all.map { |sub_c| get_template(sub_c, false) }
            }.flatten
        end
        render_success(templates.paginate(page: params[:page], per_page: params[:per_page]).as_json)
      end
    end
  end
end
