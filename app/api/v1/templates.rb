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
      get '/' do # This api only works when you will assign Positions to SubCategories using the api --> /api/v1/subcategories/assign_position"
        if params['locale'].present?
          if params['locale'] != "ar"
            render_error(RESPONSE_CODE[:not_found], I18n.t("errors.locale.not_found"))
          end
        end
        cat_id = params['category_id'].present? ? params['category_id'] : nil
        search = params['search'].present? ? params['search'].downcase : nil
        locale = params['locale'].present? ? "_#{params['locale']}" : ""

        if cat_id && search
          templates_ids = Category.find(cat_id)
          .sub_categories
          .joins(:designers)
          .joins("inner join designs on designs.id = designers.design_id")
          .joins("left join template_tags on template_tags.designer_id = designers.id")
          .joins("left join tags on template_tags.tag_id = tags.id")
          .where.not("designers.is_active = ? ", false)
          .where("lower(designs.title) LIKE ? or lower(tags.name) LIKE ? or lower(tags.name_ar) LIKE ? ", "%#{search}%", "%#{search}%", "%#{search}%")
          .select("designs.id")
          .paginate(page: params[:page], per_page: params[:per_page])
          templates = Design.where(id: templates_ids).collect{ |design| make_design_object(design) }
        elsif cat_id
          templates = SubCategory.select('subquery.*').from(
            Category.find(cat_id)
            .sub_categories
            .search_keyword(locale, search)
            .joins(:designers)
            .select("distinct sub_categories.*")
          ) 
          .joins( "INNER JOIN sort_sub_categories ON sort_sub_categories.sub_category_id = subquery.id" )
          .order("sort_sub_categories.position")
          .paginate(page: params[:page], per_page: params[:per_page])
          .all.map { |sub_c| get_template(sub_c) } # Previous One 
        else
          templates = SubCategory.select('subquery.*').from(
            all_categories
            .joins(:sub_categories)
            .joins("inner join designers on sub_categories.id = designers.sub_category_id ")
            .where("designers.approved = 'true' and designers.is_active = 'true'")
            .select("distinct sub_categories.*")
          )
          .paginate(page: params[:page], per_page: params[:per_page])
          .all.map { |sub_c| get_template(sub_c, false) }

        end
        render_success(templates.as_json)
      end

      # desc 'Get Templates  of subcategory',
      # { consumes: ['application/x-www-form-urlencoded'],
      #  http_codes: [
      #   { code: 200, message: 'success' },
      #   { code: RESPONSE_CODE[:forbidden], message: I18n.t('errors.forbidden') },
      #   { code: RESPONSE_CODE[:unprocessable_entity], message: 'Validation error messages' },
      #   { code: RESPONSE_CODE[:not_found], message: I18n.t('errors.not_found') },
      # ] }

      # params do
      #   requires :sub_category_id, type: String, :desc => 'Sub-Category Id' 
      #   requires :page, type: String, :desc => 'Page Number'
      #   requires :per_page, type: String, :desc => 'Number of elements on each page'
      # end

      
      desc 'Change Approved field status',
      { consumes: ['application/x-www-form-urlencoded'],
       http_codes: [
        { code: 200, message: 'success' },
        { code: RESPONSE_CODE[:forbidden], message: I18n.t('errors.forbidden') },
        { code: RESPONSE_CODE[:unprocessable_entity], message: 'Validation error messages' },
        { code: RESPONSE_CODE[:not_found], message: I18n.t('errors.not_found') },
      ] }

      put 'change_approved_status/:id' do
          user_id = params[:user_id].split("_")[-1]
          template = Designer.find(params[:id])
          template.update(approved: params[:approved])                    
          render_success(user_id, "Template Updated!")
      end

      desc 'Change Private field status',
      { consumes: ['application/x-www-form-urlencoded'],
       http_codes: [
        { code: 200, message: 'success' },
        { code: RESPONSE_CODE[:forbidden], message: I18n.t('errors.forbidden') },
        { code: RESPONSE_CODE[:unprocessable_entity], message: 'Validation error messages' },
        { code: RESPONSE_CODE[:not_found], message: I18n.t('errors.not_found') },
      ] }

      put 'change_private_status/:id' do
          user_id = params[:user_id].split("_")[-1]
          template = Designer.find(params[:id])
          template.update(private: params[:approved])                    
          render_success(user_id, "Template Updated!")
      end

      get 'sub_category/' do
        subcategory = SubCategory.find(params[:sub_category_id])
        templates = get_template(subcategory, false)
        render_success(templates[:images].paginate(page: params[:page], per_page: params[:per_page])) #.paginate(page: params[:page], per_page: params[:per_page]).as_json)
      end

    end
  end
end
