module V1
  class Templates < Grape::API
    include AuthenticateRequest
    include V1Base
    include FetchTemplate
    include FetchCategories
    version "v1", using: :path

    resource :templates do

      desc 'Query String search by Category Id and title',
           { consumes: ['application/x-www-form-urlencoded'],
             http_codes: [{ code: 200, message: 'success' }] }
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
          render_success(templates.as_json)          
        elsif cat_id
          templates = Category.find(cat_id).sub_categories.search_keyword(locale, search).includes(:designers).all.map { |sub_c| get_template(sub_c) } # Previous One 
          render_success(templates.as_json)
        else
          templates = all_categories.includes(:sub_categories).all
            .map { |cat| 
                cat.sub_categories.search_keyword(locale, search)
                .includes(:designers).all.map { |sub_c| get_template(sub_c, false) }
            }.flatten
          render_success(templates.as_json)
        end
      end
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


    end
  end
end
