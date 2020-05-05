module V1
  class Categories < Grape::API
    include AuthenticateRequest
    include V1Base
    version "v1", using: :path

    resource :categories do
      desc "Add Category",
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
      end

      post :create do
        category = Category.new(params)
        if category.save!
          serialization = CategorySerializer.new(category)
          render_success(serialization.as_json)
        else
          render_error(RESPONSE_CODE[:forbidden], category.errors.full_messages.join(", "))
        end
      end

      # desc "Update Category",
      #      { consumes: ["application/x-www-form-urlencoded"],
      #       http_codes: [
      #        { code: 200, message: "success" },
      #        { code: RESPONSE_CODE[:forbidden], message: I18n.t("errors.forbidden") },
      #        { code: RESPONSE_CODE[:unprocessable_entity], message: "Validation error messages" },
      #        { code: RESPONSE_CODE[:not_found], message: I18n.t("errors.not_found") },
      #      ] }
      # params do
      #   requires :title, type: String, desc: "Title"
      #   optional :description, type: String, desc: "Description"
      # end

      # put :update do
      #   if Category.update(params)
      #     render_success(response.as_json)
      #   else
      #     render_error(RESPONSE_CODE[:unauthorized], category.errors.full_messages.join(", "))
      #   end
      # end
    end
  end
end
