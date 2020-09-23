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
        cat_id = params['category_id'].present? ? params['category_id'] : nil
        search = params['search'].present? ? params['search'].downcase : nil
        if cat_id
          templates = Category.find(cat_id).sub_categories.where("lower(title) LIKE ?", "%#{search}%").includes(:designers).all.map { |sub_c| get_template(sub_c) }
          render_success(templates.as_json)
        else
          templates = all_categories.includes(:sub_categories).all.map {|cat| 
            cat.sub_categories.where("lower(title) LIKE ?", "%#{search}%").includes(:designers).all.map { |sub_c| get_template(sub_c) }
          }.flatten
          render_success(templates.as_json)
        end
      end

    end
  end
end
