module V1
  class Stocks < Grape::API
    include AuthenticateRequest
    include V1Base
    version "v1", using: :path

    resource :stocks do
      desc "Create Image",
        { consumes: ["application/x-www-form-urlencoded"],
         http_codes: [
          { code: 200, message: "success" },
          { code: RESPONSE_CODE[:forbidden], message: I18n.t("errors.forbidden") },
          { code: RESPONSE_CODE[:unprocessable_entity], message: "Validation error messages" },
          { code: RESPONSE_CODE[:not_found], message: I18n.t("errors.not_found") },
        ] }
      params do
        requires :category_id, type: String, :desc => "category"
        requires :title, type: String, :desc => "title"
        requires :stocktype, type: String, :desc => "stocktype"
        requires :source, type: String, :desc => "source"
        requires :height, type: String, :desc => "height"
        requires :size, type: String, :desc => "size"
      end

      post :create do
        stock = Stock.create(params)
        if stock.save!
          serialization = StockSerializer.new(stock)
          render_success(serialization.as_json)
        else
          render_error(RESPONSE_CODE[:unprocessable_entity], stock.errors.full_messages.join(", "))
        end
      end

      desc "Get Images by CategoryId",
        { consumes: ["application/x-www-form-urlencoded"],
         http_codes: [
          { code: 200, message: "success" },
          { code: RESPONSE_CODE[:forbidden], message: I18n.t("errors.forbidden") },
          { code: RESPONSE_CODE[:unprocessable_entity], message: "Validation error messages" },
          { code: RESPONSE_CODE[:not_found], message: I18n.t("errors.not_found") },
        ] }

      get "/:category_id" do
        stock = Stock.where(category_id: params[:category_id])
        serialization = serialize_collection(stock, serializer: StockSerializer)
        render_success(serialization.as_json)
      end

      desc "Get Image by Id",
           { consumes: ["application/x-www-form-urlencoded"],
            http_codes: [
             { code: 200, message: "success" },
             { code: RESPONSE_CODE[:forbidden], message: I18n.t("errors.forbidden") },
             { code: RESPONSE_CODE[:unprocessable_entity], message: "Validation error messages" },
             { code: RESPONSE_CODE[:not_found], message: I18n.t("errors.not_found") },
           ] }

      get "/image/:id" do
        stock = Stock.find(params[:id])
        serialization = StockSerializer.new(stock)
        render_success(serialization.as_json)
      end
    end
  end
end
