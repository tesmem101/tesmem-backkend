module V1
  class Designs < Grape::API
    include AuthenticateRequest
    include V1Base
    version 'v1', using: :path

    resource :designs do

      desc 'Create an design',
        { consumes: [ 'application/x-www-form-urlencoded' ],
          http_codes: [
            { code: 200, message: 'success' },
            { code: RESPONSE_CODE[:forbidden], message: I18n.t('errors.forbidden') },
            { code: RESPONSE_CODE[:unprocessable_entity], message: 'Validation error messages' },
            { code: RESPONSE_CODE[:not_found], message: I18n.t('errors.not_found') }
        ]}
      params do
        requires :title, type: String, desc: 'Name'
        requires :description, type: String, desc: 'Pata'
        requires :user_id, type: Integer, desc: 'Creator'
        requires :styles, type: JSON, desc: 'Creator'
      end

      post :create do
        design = Design.new(params)
        if design.save!
          serialization = DesignSerializer.new(design)
          render_success(serialization.as_json)
        else
          render_error(RESPONSE_CODE[:unauthorized], user.errors.full_messages.join(', '))
        end
      end


      desc 'Update a Design',
        { consumes: [ 'application/x-www-form-urlencoded' ],
          http_codes: [
            { code: 200, message: 'success' },
            { code: RESPONSE_CODE[:forbidden], message: I18n.t('errors.forbidden') },
            { code: RESPONSE_CODE[:unprocessable_entity], message: 'Validation error messages' },
            { code: RESPONSE_CODE[:not_found], message: I18n.t('errors.not_found') }
        ]}
      params do
        requires :title, type: String, desc: 'Name'
        requires :description, type: String, desc: 'Pata'
        requires :user_id, type: Integer, desc: 'Creator'
        requires :styles, type: JSON, desc: 'Creator'
      end

      put "/:id" do
        design = Design.find(params[:id])
        if design.update!(params)
          serialization = DesignSerializer.new(design)
          render_success(serialization.as_json)
        else
          render_error(RESPONSE_CODE[:unauthorized], user.errors.full_messages.join(', '))
        end
      end

      desc "Delete Design",
           { consumes: ["application/x-www-form-urlencoded"],
            http_codes: [
             { code: 200, message: "success" },
             { code: RESPONSE_CODE[:forbidden], message: I18n.t("errors.forbidden") },
             { code: RESPONSE_CODE[:unprocessable_entity], message: "Validation error messages" },
             { code: RESPONSE_CODE[:not_found], message: I18n.t("errors.not_found") },
           ] }

      delete "/:id" do
        Design.find(params[:id]).destroy
        render_success("Design Deleted Successfully".as_json)
      end
    end
  end
end
