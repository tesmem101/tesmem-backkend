module V1
  class Folders < Grape::API
    include AuthenticateRequest
    include V1Base
    version "v1", using: :path

    resource :folders do
      desc "Create Folder",
           { consumes: ["application/x-www-form-urlencoded"],
            http_codes: [
             { code: 200, message: "success" },
             { code: RESPONSE_CODE[:forbidden], message: I18n.t("errors.forbidden") },
             { code: RESPONSE_CODE[:unprocessable_entity], message: "Validation error messages" },
             { code: RESPONSE_CODE[:not_found], message: I18n.t("errors.not_found") },
           ] }
      params do
        requires :name, type: String, desc: "Name"
        requires :user_id, type: Integer, desc: "Creator"
      end

      post do
        folder = Folder.where(params).first
        if folder.nil?
          folder = Folder.new(params)
          if folder.save!
            serialization = FolderSerializer.new(folder)
            render_success(serialization.as_json)
          end
        else
          render_error(RESPONSE_CODE[:forbidden], "forbidden", "Folder already exist".as_json)
        end
      end

      desc "Get Folder",
           { consumes: ["application/x-www-form-urlencoded"],
            http_codes: [
             { code: 200, message: "success" },
             { code: RESPONSE_CODE[:forbidden], message: I18n.t("errors.forbidden") },
             { code: RESPONSE_CODE[:unprocessable_entity], message: "Validation error messages" },
             { code: RESPONSE_CODE[:not_found], message: I18n.t("errors.not_found") },
           ] }

      get "/:id" do
        user_id = params[:id]
        folder = Folder.where(user_id: user_id)
        serialization = serialize_collection(folder, serializer: FolderSerializer)
        render_success(serialization.as_json)
      end

      desc "Update Folder",
           { consumes: ["application/x-www-form-urlencoded"],
            http_codes: [
             { code: 200, message: "success" },
             { code: RESPONSE_CODE[:forbidden], message: I18n.t("errors.forbidden") },
             { code: RESPONSE_CODE[:unprocessable_entity], message: "Validation error messages" },
             { code: RESPONSE_CODE[:not_found], message: I18n.t("errors.not_found") },
           ] }
      params do
        requires :name, type: String, desc: "Name"
        requires :user_id, type: Integer, desc: "Creator"
      end

      put "/:id" do
        folder = Folder.find(params[:id])
        if folder.update!(params)
          serialization = FolderSerializer.new(folder)
          render_success(serialization.as_json)
        else
          render_error(RESPONSE_CODE[:unauthorized], folder.errors.full_messages.join(", "))
        end
      end

      desc "Delete Folder",
           { consumes: ["application/x-www-form-urlencoded"],
            http_codes: [
             { code: 200, message: "success" },
             { code: RESPONSE_CODE[:forbidden], message: I18n.t("errors.forbidden") },
             { code: RESPONSE_CODE[:unprocessable_entity], message: "Validation error messages" },
             { code: RESPONSE_CODE[:not_found], message: I18n.t("errors.not_found") },
           ] }

      delete "/:id" do
        folder = Folder.find(params[:id])
        if folder.destroy
          render_success("Folder deleted".as_json)
        end
      end
    end
  end
end
