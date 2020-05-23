module V1
  class Stocks < Grape::API
    include AuthenticateRequest
    include V1Base
    version "v1", using: :path

    resource :stocks do
      # CREATE
      desc "Create Image",
        { consumes: ["application/x-www-form-urlencoded"],
         http_codes: [
          { code: 200, message: "success" },
          { code: RESPONSE_CODE[:forbidden], message: I18n.t("errors.forbidden") },
          { code: RESPONSE_CODE[:unprocessable_entity], message: "Validation error messages" },
          { code: RESPONSE_CODE[:not_found], message: I18n.t("errors.not_found") },
        ] }
      params do
        requires :category_id, type: Integer, :desc => "category"
        requires :sub_category_id, type: Integer, :desc => "subcategory id"
        requires :title, type: String, :desc => "title"
        requires :stocktype, type: String, :desc => "stocktype"
        requires :source, type: String, :desc => "source"
        requires :height, type: String, :desc => "height"
        requires :size, type: String, :desc => "size"
      end
      post :create do
        stock = Stock.new(params)
        if stock.save!
          serialization = StockSerializer.new(stock)
          render_success(serialization.as_json)
        else
          render_error(RESPONSE_CODE[:unprocessable_entity], stock.errors.full_messages.join(", "))
        end
      end
      # SHOW
      desc "Get Image by Id",
           { consumes: ["application/x-www-form-urlencoded"],
             http_codes: [{ code: 200, message: "success" }] }

      get "/:id" do
        stock = Stock.find(params[:id])
        serialization = StockSerializer.new(stock)
        render_success(serialization.as_json)
      end
      # DESTROY
      desc "Delete Image",
           { consumes: ["application/x-www-form-urlencoded"],
             http_codes: [{ code: 200, message: "success" }] }
      delete "/:id" do
        Stock.find(params[:id]).destroy
        render_success("Image Deleted Successfully".as_json)
      end

      desc "Get Images by CategoryId",
           { consumes: ["application/x-www-form-urlencoded"],
             http_codes: [{ code: 200, message: "success" }] }
      get "/category/:id" do
        stock = Stock.where(category_id: params[:id])
        serialization = serialize_collection(stock, serializer: StockSerializer)
        render_success(serialization.as_json)
      end

      desc "Get Images by SubCategoryId",
           { consumes: ["application/x-www-form-urlencoded"],
             http_codes: [{ code: 200, message: "success" }] }

      get "/subcategory/:id" do
        stock = Stock.where(sub_category_id: params[:id])
        serialization = serialize_collection(stock, serializer: StockSerializer)
        render_success(serialization.as_json)
      end
    end
  end
end
