module V1
  class Animations < Grape::API
    include AuthenticateRequest
    include V1Base
    include FetchTemplate
    version "v1", using: :path

    resource :animations do

      desc "Add Sub Category to Animation Category",
        { consumes: ["application/x-www-form-urlencoded"],
         http_codes: [
          { code: 200, message: "success" },
          { code: RESPONSE_CODE[:forbidden], message: I18n.t("errors.forbidden") },
          { code: RESPONSE_CODE[:unprocessable_entity], message: "Validation error messages" },
          { code: RESPONSE_CODE[:not_found], message: I18n.t("errors.not_found") },
        ] }
      params do
        requires :title, type: String, desc: 'Title'
        optional :description, type: String, desc: 'Description'
      end
      post "subcategory/create" do
        category = Category.where(title: TITLES[:animation]).first_or_create
        params['category_id'] = category.id
        subcategory = SubCategory.new(params)
        if subcategory.save!
          serialization = SubCategorySerializer.new(subcategory)
          render_success(serialization.as_json)
        else
          render_error(RESPONSE_CODE[:forbidden], subcategory.errors.full_messages.join(', '))
        end
      end
      desc "Add animations to stocks",
        { consumes: ["application/x-www-form-urlencoded"],
         http_codes: [
          { code: 200, message: "success" },
          { code: RESPONSE_CODE[:forbidden], message: I18n.t("errors.forbidden") },
          { code: RESPONSE_CODE[:unprocessable_entity], message: "Validation error messages" },
          { code: RESPONSE_CODE[:not_found], message: I18n.t("errors.not_found") },
        ] }
      params do
        requires :title, type: String, :desc => 'title'
        requires :image, type: File, :desc => 'source'
        requires :sub_category_id, type: Integer, :desc => 'sub category id'
      end
      post :create do
        category = Category.where(title: TITLES[:animation]).first
        params['category_id'] = category.id
        stock = Stock.new(params)
        if stock.save!
          serialization = StockSerializer.new(stock)
          render_success(serialization.as_json)
        else
          render_error(RESPONSE_CODE[:unauthorized], user.errors.full_messages.join(", "))
        end
      end
      desc 'Get sub categories of animations',
           { consumes: ['application/x-www-form-urlencoded'],
             http_codes: [{ code: 200, message: 'success' }] }
      get '/subcatgories/all' do
        sub_categories = Category.where(title: TITLES[:animation]).includes(:sub_categories).map(&:sub_categories).flatten
        serialization = serialize_collection(sub_categories, serializer: SubCategorySerializer)
        render_success(serialization.as_json)
      end
      desc 'Query String search by title',
           { consumes: ['application/x-www-form-urlencoded'],
             http_codes: [{ code: 200, message: 'success' }] }
      get '/' do
        search = params['search'].present? ? params['search'].downcase : nil
        category = Category.where(title: TITLES[:animation])
        searched_animations = []
        if category.present?
          searched_animations = category.first.sub_categories.where("lower(title) LIKE ?", "%#{search}%").includes(:stocks).all.map { |sub_c| get_template(sub_c) }
        end
        render_success(searched_animations.as_json)
      end
    end
  end
end
