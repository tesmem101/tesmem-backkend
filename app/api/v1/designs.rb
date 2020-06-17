module V1
  class Designs < Grape::API
    include AuthenticateRequest
    include V1Base
    include AuthenticateUser
    include SaveImage
    # include CarrierWave::RMagick
    version "v1", using: :path

    resource :designs do

      desc "Create a design",
        { consumes: ["application/x-www-form-urlencoded"],
         http_codes: [
          { code: 200, message: "success" },
          { code: RESPONSE_CODE[:forbidden], message: I18n.t("errors.forbidden") },
          { code: RESPONSE_CODE[:unprocessable_entity], message: "Validation error messages" },
          { code: RESPONSE_CODE[:not_found], message: I18n.t("errors.not_found") },
        ] }
      params do
        requires :title, type: String, desc: "Name"
        optional :description, type: String, desc: "Pata"
        requires :user_id, type: Integer, desc: "Creator"
        requires :styles, type: JSON, desc: "Styles"
        optional :height, type: String, desc: "Height"
        optional :width, type: String, desc: "Width"
        requires :image, type: String, desc: "Image"
      end
      post :create do
        params[:image] = encode_image(params[:title], params[:image])
        design = Design.new(params)
        if design.save!
          insert_image(design)
          serialization = DesignSerializer.new(design)
          render_success(serialization.as_json)
        else
          render_error(RESPONSE_CODE[:unauthorized], user.errors.full_messages.join(", "))
        end
      end
      desc "Update a Design",
        { consumes: ["application/x-www-form-urlencoded"],
         http_codes: [
          { code: 200, message: "success" },
          { code: RESPONSE_CODE[:forbidden], message: I18n.t("errors.forbidden") },
          { code: RESPONSE_CODE[:unprocessable_entity], message: "Validation error messages" },
          { code: RESPONSE_CODE[:not_found], message: I18n.t("errors.not_found") },
        ] }
      params do
        requires :title, type: String, desc: "Name"
        optional :description, type: String, desc: "Description"
        requires :user_id, type: Integer, desc: "Creator"
        requires :styles, type: JSON, desc: "Styles"
        optional :height, type: String, desc: "Height"
        optional :width, type: String, desc: "Width"
      end
      put "/:id" do
        params[:image] = encode_image(params[:title], params[:image])
        design = Design.find(params[:id])
        if design.update!(params)
          update_image(design)
          serialization = DesignSerializer.new(design)
          render_success(serialization.as_json)
        else
          render_error(RESPONSE_CODE[:unauthorized], user.errors.full_messages.join(", "))
        end
      end
      desc "Delete Design",
           { consumes: ["application/x-www-form-urlencoded"],
             http_codes: [{ code: 200, message: "success" }] }
      delete "/:id" do
        Design.find(params[:id]).destroy
        render_success("Design Deleted Successfully".as_json)
      end
      desc "Get Designs",
           { consumes: ["application/x-www-form-urlencoded"],
             http_codes: [{ code: 200, message: "success" }] }
      before { authenticate_user }
      get "/" do
        design = authenticate_user.designs
        serialization = serialize_collection(design, serializer: DesignSerializer)
        render_success(serialization.as_json)
      end
      desc "Show design",
           { consumes: ["application/x-www-form-urlencoded"],
             http_codes: [{ code: 200, message: "success" }] }
      before { authenticate_user }
      get "/:id" do
        design = authenticate_user.designs.where(id: params[:id])
        serialization = serialize_collection(design, serializer: DesignSerializer)
        render_success(serialization.as_json)
      end
    end
  end
end
