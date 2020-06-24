module V1
  class Icons < Grape::API
    include AuthenticateRequest
    include V1Base
    version "v1", using: :path

    resource :icons do

      desc "Add Sub Category to Icon Category",
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
        category = Category.where(title: TITLES[:icon]).first_or_create
        params['category_id'] = category.id
        subcategory = SubCategory.new(params)
        if subcategory.save!
          serialization = SubCategorySerializer.new(subcategory)
          render_success(serialization.as_json)
        else
          render_error(RESPONSE_CODE[:forbidden], subcategory.errors.full_messages.join(', '))
        end
      end
      desc "Add icons to stocks",
        { consumes: ["application/x-www-form-urlencoded"],
         http_codes: [
          { code: 200, message: "success" },
          { code: RESPONSE_CODE[:forbidden], message: I18n.t("errors.forbidden") },
          { code: RESPONSE_CODE[:unprocessable_entity], message: "Validation error messages" },
          { code: RESPONSE_CODE[:not_found], message: I18n.t("errors.not_found") },
        ] }
      params do
        requires :title, type: String, :desc => 'title'
        requires :stocktype, type: String, :desc => 'stocktype'
        requires :source, type: String, :desc => 'source'
        requires :height, type: String, :desc => 'height'
        requires :size, type: String, :desc => 'size'
        requires :sub_category_id, type: Integer, :desc => 'sub category id'
      end
      post :create do
        category = Category.where(title: TITLES[:icon]).first
        params['category_id'] = category.id
        stock = Stock.new(params)
        if stock.save!
          serialization = StockSerializer.new(stock)
          render_success(serialization.as_json)
        else
          render_error(RESPONSE_CODE[:unauthorized], user.errors.full_messages.join(", "))
        end
      end
      desc 'Get sub categories of icons',
           { consumes: ['application/x-www-form-urlencoded'],
             http_codes: [{ code: 200, message: 'success' }] }
      get '/subcatgories/all' do
        sub_categories = Category.where(title: TITLES[:icon]).first.sub_categories
        serialization = serialize_collection(sub_categories, serializer: SubCategorySerializer)
        render_success(serialization.as_json)
      end
      desc 'Query String search by title',
           { consumes: ['application/x-www-form-urlencoded'],
             http_codes: [{ code: 200, message: 'success' }] }
      get '/' do
        search = params['search'].present? ? params['search'].downcase : nil
        searched_icons = Category.where(title: TITLES[:icon]).first.sub_categories.where("lower(title) LIKE ?", "%#{search}%").includes(:stocks).all.map { |sub_c| {id: sub_c.id, name: sub_c.title, data: serialize_collection(sub_c.stocks, serializer: StockSerializer)}}
        render_success(searched_icons.as_json)
      end
    end
  end
end
