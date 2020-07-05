module V1
  class Backgrounds < Grape::API
    include AuthenticateRequest
    include V1Base
    version "v1", using: :path

    resource :backgrounds do

      desc "Add backgrounds to stocks",
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
        requires :url, type: String, :desc => 'source'
        requires :height, type: String, :desc => 'height'
        requires :size, type: String, :desc => 'size'
      end
      post :create do
        category = Category.where(title: TITLES[:background]).first_or_create
        sub_category = SubCategory.where(title: TITLES[:background]).first_or_create({category_id:category.id})
        params['category_id'] = category.id
        params['sub_category_id'] = sub_category.id
        stock = Stock.new(params)
        if stock.save!
          serialization = StockSerializer.new(stock)
          render_success(serialization.as_json)
        else
          render_error(RESPONSE_CODE[:unauthorized], user.errors.full_messages.join(", "))
        end
      end
      desc 'Query String search by title',
           { consumes: ['application/x-www-form-urlencoded'],
             http_codes: [{ code: 200, message: 'success' }] }
      get '/' do
        search = params['search'].present? ? params['search'].downcase : nil
        category = Category.where(title: TITLES[:background])
        stocks = []
        if category.present?
          stocks = category.first.sub_categories.find_by_title(TITLES[:background]).stocks.where("lower(title) LIKE ?", "%#{search}%")
        end
        serialization = serialize_collection(stocks, serializer: StockSerializer)
        render_success(serialization.as_json)
      end
    end
  end
end
