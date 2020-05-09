module V1
  class Stocks < Grape::API
    include AuthenticateRequest
    include V1Base
    version "v1", using: :path

    resource :stocks do
      desc "upload Image",
        { consumes: ["application/x-www-form-urlencoded"],
         http_codes: [
          { code: 200, message: "success" },
          { code: RESPONSE_CODE[:forbidden], message: I18n.t("errors.forbidden") },
          { code: RESPONSE_CODE[:unprocessable_entity], message: "Validation error messages" },
          { code: RESPONSE_CODE[:not_found], message: I18n.t("errors.not_found") },
        ] }
      params do
        requires :category_id, type: String, :desc => "category"
        optional :file, type: Array do
          requires :image, :type => Rack::Multipart::UploadedFile, :desc => "Stock Images."
        end
      end

      post :create do
        uploader = ImageUploader.new
        uploader.store!(params[:image])
        stock = Stock.new(title: uploader.identifier, description: uploader.current_path, path: uploader.url, category_id: params[:category_id])

        if stock.save!
          serialization = StockSerializer.new(stock)
          render_success(serialization.as_json)
        else
          render_error(RESPONSE_CODE[:unprocessable_entity], stock.errors.full_messages.join(", "))
        end
      end
    end
  end
end
