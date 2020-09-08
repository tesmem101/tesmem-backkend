module V1
  class Backgrounds < Grape::API
    include AuthenticateRequest
    include V1Base
    include FetchUnsplash
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
        requires :image, type: File, :desc => 'source'
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
        search = params['search'].present? ? params['search'].downcase : 'background'
        unsplash_images = []
        page_limit = 1
        for page_number in 1..page_limit do
          unsplash_images.concat get_unsplash_images(search, page_number, 'portrait', 20, 'latest').map { |photo| map_unsplash_backgrounds(photo.table, 'regular') }
        end
        render_success(unsplash_images.as_json)
      end
    end
  end
end
