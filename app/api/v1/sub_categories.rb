module V1
  class SubCategories < Grape::API
    include AuthenticateRequest
    include V1Base
    version "v1", using: :path

    resource :subcategories do
      desc "Add SubCategory",
           { consumes: ["application/x-www-form-urlencoded"],
            http_codes: [
             { code: 200, message: "success" },
             { code: RESPONSE_CODE[:forbidden], message: I18n.t("errors.forbidden") },
             { code: RESPONSE_CODE[:unprocessable_entity], message: "Validation error messages" },
             { code: RESPONSE_CODE[:not_found], message: I18n.t("errors.not_found") },
           ] }
      params do
        requires :title, type: String, desc: "Title"
        optional :description, type: String, desc: "Description"
        requires :category_id, type: Integer, desc: "Category Id"
      end
      post "/create" do
        subcategory = SubCategory.new(params)
        if subcategory.save!
          serialization = SubCategorySerializer.new(subcategory)
          render_success(serialization.as_json)
        else
          render_error(RESPONSE_CODE[:forbidden], subcategory.errors.full_messages.join(", "))
        end
      end

      desc "Get all Subcategories",
           { consumes: ["application/x-www-form-urlencoded"],
            http_codes: [
             { code: 200, message: "success" },
             { code: RESPONSE_CODE[:forbidden], message: I18n.t("errors.forbidden") },
             { code: RESPONSE_CODE[:unprocessable_entity], message: "Validation error messages" },
             { code: RESPONSE_CODE[:not_found], message: I18n.t("errors.not_found") },
           ] }
      get "/all" do
        subcategory = SubCategory.all
        serialization = serialize_collection(subcategory, serializer: SubCategorySerializer)
        render_success(serialization.as_json)
      end

      desc "Get SubCategory",
           { consumes: ["application/x-www-form-urlencoded"],
            http_codes: [
             { code: 200, message: "success" },
             { code: RESPONSE_CODE[:forbidden], message: I18n.t("errors.forbidden") },
             { code: RESPONSE_CODE[:unprocessable_entity], message: "Validation error messages" },
             { code: RESPONSE_CODE[:not_found], message: I18n.t("errors.not_found") },
           ] }
      get "/:id" do
        subcategory = SubCategory.find(params[:id])
        if subcategory.present?
          serialization = SubCategorySerializer.new(subcategory)
          render_success(serialization.as_json)
        end
      end

      desc "Update SubCategory",
           { consumes: ["application/x-www-form-urlencoded"],
            http_codes: [
             { code: 200, message: "success" },
             { code: RESPONSE_CODE[:forbidden], message: I18n.t("errors.forbidden") },
             { code: RESPONSE_CODE[:unprocessable_entity], message: "Validation error messages" },
             { code: RESPONSE_CODE[:not_found], message: I18n.t("errors.not_found") },
           ] }
      params do
        requires :title, type: String, desc: "Title"
        optional :description, type: String, desc: "Description"
        requires :category_id, type: Integer, desc: "Category Id"
      end
      put "/update/:id" do
        subcategory = SubCategory.find(params[:id])
        if subcategory.update(params)
          serialization = SubCategorySerializer.new(subcategory)
          render_success(serialization.as_json)
        else
          render_error(RESPONSE_CODE[:unprocessable_entity], subcategory.errors.full_messages.join(", "))
        end
      end

      desc "Delete SubCategory",
           { consumes: ["application/x-www-form-urlencoded"],
            http_codes: [
             { code: 200, message: "success" },
             { code: RESPONSE_CODE[:forbidden], message: I18n.t("errors.forbidden") },
             { code: RESPONSE_CODE[:unprocessable_entity], message: "Validation error messages" },
             { code: RESPONSE_CODE[:not_found], message: I18n.t("errors.not_found") },
           ] }

      delete "/delete/:id" do
        SubCategory.find(params[:id]).destroy
        render_success("SubCategory Deleted Successfully".as_json)
      end

      desc "Get All Subategories with Images",
        { consumes: ["application/x-www-form-urlencoded"],
         http_codes: [
          { code: 200, message: "success" },
          { code: RESPONSE_CODE[:forbidden], message: I18n.t("errors.forbidden") },
          { code: RESPONSE_CODE[:unprocessable_entity], message: "Validation error messages" },
          { code: RESPONSE_CODE[:not_found], message: I18n.t("errors.not_found") },
        ] }

      get "stocks/all" do
        subcategory = SubCategory.all.includes(:stocks)
        serialization = serialize_collection(subcategory, serializer: SubCategorySerializer)
        render_success(serialization.as_json)
      end
    end
  end
end
