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
          requires :images, :type => Rack::Multipart::UploadedFile, :desc => "Stock Images."
        end
      end

      post :file do
        uploader = ImageUploader.new
        uploader.store!(params[:images])

        stock = Stock.new
        stock.title = uploader.identifier
        stock.description = uploader.current_path
        stock.path = uploader.url
        stock.category_id = params[:category_id]
        if stock.save!
          render_success(serialization.as_json)
          # uploader.retrieve_from_store!(params[:path])
        else
          render_error(RESPONSE_CODE[:unprocessable_entity], stock.errors.full_messages.join(", "))
        end
      end
    end
  end
end
